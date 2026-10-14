package com.student.servlet;

import com.student.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Servlet responsible for streaming student images and documents from the filesystem.
 * Handles &lt;img&gt; tag requests and document download/preview requests.
 * 
 * URLs:
 * - /student-image?id=1
 * - /student-document?id=1
 */
@WebServlet(name = "FileStreamServlet", urlPatterns = {"/student-image", "/student-document", "/file-stream"})
public class FileStreamServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Optional external upload folder fallback
    private static final String EXTERNAL_UPLOAD_DIR = "C:\\xampp\\student_uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath();
        boolean isImageRequest = "/student-image".equalsIgnoreCase(servletPath);
        
        String idParam = request.getParameter("id");
        String fileParam = request.getParameter("file");
        String fileName = null;

        // 1. Resolve file name from MySQL if student ID is provided
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int studentId = Integer.parseInt(idParam.trim());
                String column = isImageRequest ? "photo" : "document";
                String sql = "SELECT " + column + " FROM students WHERE id = ?";

                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, studentId);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            fileName = rs.getString(column);
                        }
                    }
                }
            } catch (Exception e) {
                System.err.println("[FileStreamServlet] Error querying file for student ID " + idParam + ": " + e.getMessage());
            }
        } else if (fileParam != null && !fileParam.trim().isEmpty()) {
            // Prevent directory traversal attacks
            fileName = new File(fileParam.trim()).getName();
        }

        // 2. Locate the file on the server filesystem
        File targetFile = null;
        if (fileName != null && !fileName.trim().isEmpty()) {
            // Primary location: web application's uploads folder
            String appUploadsPath = getServletContext().getRealPath("/uploads");
            if (appUploadsPath != null) {
                File fileInApp = new File(appUploadsPath, fileName);
                if (fileInApp.exists() && fileInApp.isFile()) {
                    targetFile = fileInApp;
                }
            }

            // Secondary location: external uploads directory fallback
            if (targetFile == null) {
                File externalFile = new File(EXTERNAL_UPLOAD_DIR, fileName);
                if (externalFile.exists() && externalFile.isFile()) {
                    targetFile = externalFile;
                }
            }
        }

        // 3. If file not found, handle gracefully
        if (targetFile == null || !targetFile.exists()) {
            if (isImageRequest) {
                // Stream a generated default SVG avatar if image is missing
                streamDefaultAvatar(response);
                return;
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Document file not found: " + fileName);
                return;
            }
        }

        // 4. Determine MIME type and headers
        String mimeType = getServletContext().getMimeType(targetFile.getName());
        if (mimeType == null) {
            if (isImageRequest) {
                mimeType = "image/png";
            } else if (targetFile.getName().toLowerCase().endsWith(".pdf")) {
                mimeType = "application/pdf";
            } else {
                mimeType = "application/octet-stream";
            }
        }

        response.setContentType(mimeType);
        response.setContentLengthLong(targetFile.length());
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        if (!isImageRequest) {
            String downloadParam = request.getParameter("download");
            boolean isDownload = "true".equalsIgnoreCase(downloadParam) || "1".equals(downloadParam);
            String disposition = isDownload ? "attachment" : "inline";
            response.setHeader("Content-Disposition", disposition + "; filename=\"" + targetFile.getName() + "\"");
        }

        // 5. Stream file bytes to response output stream
        try (BufferedInputStream in = new BufferedInputStream(new FileInputStream(targetFile));
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            out.flush();
        }
    }

    /**
     * Fallback to render an inline SVG placeholder avatar if the student photo is missing.
     */
    private void streamDefaultAvatar(HttpServletResponse response) throws IOException {
        response.setContentType("image/svg+xml");
        String svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100' width='100' height='100'>"
                   + "<rect width='100' height='100' fill='#e2e8f0' rx='50'/>"
                   + "<circle cx='50' cy='38' r='18' fill='#94a3b8'/>"
                   + "<path d='M22 84 A28 28 0 0 1 78 84 Z' fill='#94a3b8'/>"
                   + "</svg>";
        byte[] bytes = svg.getBytes(StandardCharsets.UTF_8);
        response.setContentLength(bytes.length);
        try (OutputStream out = response.getOutputStream()) {
            out.write(bytes);
            out.flush();
        }
    }
}

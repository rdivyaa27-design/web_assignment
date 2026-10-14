document.getElementById("registerForm").addEventListener("submit", function(event) {
    event.preventDefault();
    const name = document.getElementById("name").value.trim();
    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value;
    const file = document.getElementById("file").files[0];
    const error = document.getElementById("error");
    error.textContent = "";
    error.classList.remove("success");
    if (name === "") {
        error.textContent = "Name is required.";
        return;
    }
    // Simple email format validation
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(email)) {
        error.textContent = "Please enter a valid email address.";
        return;
    }
    // Password must be at least 8 characters and include a letter and a number
    const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d).{8,}$/;
    if (!passwordPattern.test(password)) {
        error.textContent = "Password must be at least 8 characters and include a letter and a number.";
        return;
    }
    if (!file) {
        error.textContent = "Please upload a file.";
        return;
    }
    error.textContent = "Registration successful!";
    error.classList.add("success");
});

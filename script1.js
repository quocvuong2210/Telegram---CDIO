document.addEventListener("DOMContentLoaded", function() {
    const loginForm = document.getElementById("login-form");
    if (loginForm) {
        loginForm.addEventListener("submit", function(event) {
            event.preventDefault();
            const phone = document.getElementById("login-phone").value;
            alert("Đang xử lý đăng nhập cho số: +84 " + phone);
        });
    }

    const registerForm = document.getElementById("register-form");
    if (registerForm) {
        registerForm.addEventListener("submit", function(event) {
            event.preventDefault();
            const phone = document.getElementById("reg-phone").value;
            const firstName = document.getElementById("first-name").value;
            alert(
                "Đang xử lý đăng ký cho: " + firstName + " (Số ĐT: +84 " + phone + ")",
            );
        });
    }
});
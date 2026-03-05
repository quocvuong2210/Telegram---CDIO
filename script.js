document.addEventListener("DOMContentLoaded", () => {
    const menuBtn = document.getElementById("menuBtn");
    const dropdownMenu = document.getElementById("dropdownMenu");

    menuBtn.addEventListener("click", (e) => {
        e.stopPropagation();
        dropdownMenu.classList.toggle("show");
    });

    document.addEventListener("click", (e) => {
        if (!dropdownMenu.contains(e.target) && e.target !== menuBtn) {
            dropdownMenu.classList.remove("show");
        }
    });

    document.querySelectorAll(".menu-item").forEach((item) => {
        item.addEventListener("click", () => {
            const action = item.innerText.trim();

            dropdownMenu.classList.remove("show");

            if (action === "Mute") alert("Notifications Muted");
            else if (action === "Block user") alert("User Blocked!");
            else console.log("Selected: " + action);
        });
    });

    window.selectContact = function(element, name, avatarSrc, isOfficial) {
        document
            .querySelectorAll(".contact-item")
            .forEach((el) => el.classList.remove("active"));

        element.classList.add("active");

        document.getElementById("headerName").innerHTML =
            name +
            (isOfficial ? ' <i class="fas fa-check-circle official-icon"></i>' : "");
        document.getElementById("headerAvatar").src = avatarSrc;

        const statuses = [
            "online",
            "last seen recently",
            "last seen 5 minutes ago",
        ];
        document.getElementById("headerStatus").innerText =
            statuses[Math.floor(Math.random() * statuses.length)];

        const chatBody = document.getElementById("chatBody");
        chatBody.innerHTML = "";

        chatBody.innerHTML = `
            <div class="empty-state">
                <div class="sticker-placeholder"><i class="fas fa-cat" style="font-size: 80px; color: #fff;"></i></div>
                <h4>No messages here yet...</h4>
                <p>Send a message to ${name}.</p>
            </div>
        `;
    };

    const messageInput = document.getElementById("messageInput");
    const sendBtn = document.getElementById("sendBtn");
    const chatBody = document.getElementById("chatBody");
    const micIcon = document.getElementById("micIcon");

    messageInput.addEventListener("input", function() {
        if (this.value.trim().length > 0) {
            micIcon.classList.remove("fa-microphone");
            micIcon.classList.add("fa-paper-plane");
            micIcon.style.color = "#3390ec";
        } else {
            micIcon.classList.add("fa-microphone");
            micIcon.classList.remove("fa-paper-plane");
            micIcon.style.color = "#707579";
        }
    });

    function sendMessage() {
        const text = messageInput.value.trim();
        if (text === "") return;

        const emptyState = document.querySelector(".empty-state");
        if (emptyState) emptyState.remove();

        const time = new Date().toLocaleTimeString([], {
            hour: "2-digit",
            minute: "2-digit",
        });

        const msgHtml = `
            <div class="message sent">
                ${text}
                <span class="msg-time">${time} <i class="fas fa-check"></i></span>
            </div>
        `;

        chatBody.insertAdjacentHTML("beforeend", msgHtml);
        messageInput.value = "";

        micIcon.classList.add("fa-microphone");
        micIcon.classList.remove("fa-paper-plane");
        micIcon.style.color = "#707579";

        chatBody.scrollTop = chatBody.scrollHeight;
    }

    sendBtn.addEventListener("click", sendMessage);

    messageInput.addEventListener("keypress", (e) => {
        if (e.key === "Enter") {
            sendMessage();
        }
    });

    const searchInput = document.getElementById("searchInput");
    searchInput.addEventListener("keyup", function() {
        const value = this.value.toLowerCase();
        const contacts = document.querySelectorAll(".contact-item");

        contacts.forEach((contact) => {
            const name = contact.querySelector(".name").innerText.toLowerCase();
            if (name.indexOf(value) > -1) {
                contact.style.display = "flex";
            } else {
                contact.style.display = "none";
            }
        });
    });
});
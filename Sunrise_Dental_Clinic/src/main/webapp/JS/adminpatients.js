document.addEventListener("DOMContentLoaded", function () {
    initializeSidebar();
    initializeAddPatientForm();
    initializeUpdatePatientForm();
    initializePatientIdFormatting();
    initializePhoneFormatting();
    initializeAutoHideAlerts();
});

function initializeSidebar() {
    const toggleMenu = document.getElementById("toggleMenu");
    const sidebar = document.getElementById("sidebar");

    if (!toggleMenu || !sidebar) {
        return;
    }

    toggleMenu.addEventListener("click", function () {
        sidebar.classList.toggle("open");
    });

    document.addEventListener("click", function (event) {
        if (
            window.innerWidth <= 900 &&
            sidebar.classList.contains("open") &&
            !sidebar.contains(event.target) &&
            !toggleMenu.contains(event.target)
        ) {
            sidebar.classList.remove("open");
        }
    });

    window.addEventListener("resize", function () {
        if (window.innerWidth > 900) {
            sidebar.classList.remove("open");
        }
    });
}

function initializeAddPatientForm() {
    const form = document.getElementById("addPatientForm");

    if (!form) {
        return;
    }

    form.addEventListener("submit", function (event) {
        let valid = true;

        clearValidationErrors();

        const patientId = document.getElementById("patient_id");

        if (
            patientId &&
            !patientId.value.trim().match(/^PN-\d{4}$/)
        ) {
            showFieldError(
                patientId,
                "patientIdError",
                "Use the format PN-0001."
            );
            valid = false;
        }

        const patientName = document.getElementById("patient_name");

        if (
            patientName &&
            patientName.value.trim().length < 2
        ) {
            showFieldError(
                patientName,
                "patientNameError",
                "Please enter the patient name."
            );
            valid = false;
        }

        const address = document.getElementById("address");

        if (
            address &&
            address.value.trim().length < 3
        ) {
            showFieldError(
                address,
                "addressError",
                "Please enter the patient's address."
            );
            valid = false;
        }

        const contact = document.getElementById("contact_number");

        if (
            contact &&
            !/^[0-9+\- ]{7,15}$/.test(contact.value.trim())
        ) {
            showFieldError(
                contact,
                "contactError",
                "Please enter a valid contact number."
            );
            valid = false;
        }

        const gender = document.getElementById("gender");

        if (gender && !gender.value) {
            showFieldError(
                gender,
                "genderError",
                "Please select a gender."
            );
            valid = false;
        }

        if (!valid) {
            event.preventDefault();

            const firstError =
                document.querySelector(".input-error");

            if (firstError) {
                firstError.focus();
            }

            return;
        }

        const button =
            document.getElementById("submitButton");

        if (button) {
            button.disabled = true;
            button.innerHTML =
                '<i class="fas fa-spinner fa-spin"></i> Registering...';
        }
    });
}

function initializeUpdatePatientForm() {
    const form =
        document.getElementById("updatePatientForm");

    if (!form) {
        return;
    }

    form.addEventListener("submit", function (event) {
        let valid = true;

        clearValidationErrors();

        const patientName =
            document.getElementById("patient_name");

        if (
            patientName &&
            (
                !patientName.value.trim() ||
                patientName.value.trim().length < 2
            )
        ) {
            showFieldError(
                patientName,
                "patientNameError",
                "Please enter the patient name."
            );
            valid = false;
        }

        const address =
            document.getElementById("address");

        if (
            address &&
            (
                !address.value.trim() ||
                address.value.trim().length < 3
            )
        ) {
            showFieldError(
                address,
                "addressError",
                "Please enter the address."
            );
            valid = false;
        }

        const contact =
            document.getElementById("contact_number");

        if (
            contact &&
            !/^[0-9+\- ]{7,15}$/.test(contact.value.trim())
        ) {
            showFieldError(
                contact,
                "contactError",
                "Please enter a valid contact number."
            );
            valid = false;
        }

        if (!valid) {
            event.preventDefault();

            const firstError =
                document.querySelector(".input-error");

            if (firstError) {
                firstError.focus();
            }

            return;
        }

        const button =
            form.querySelector(".submit-btn");

        if (button) {
            button.disabled = true;
            button.innerHTML =
                '<i class="fas fa-spinner fa-spin"></i> Saving...';
        }
    });
}

function initializePatientIdFormatting() {
    const patientId =
        document.getElementById("patient_id");

    if (!patientId || patientId.readOnly) {
        return;
    }

    patientId.addEventListener("input", function () {
        let value =
            patientId.value.toUpperCase();

        value = value.replace(/[^A-Z0-9-]/g, "");

        if (
            value.length > 0 &&
            !value.startsWith("PN-")
        ) {
            const digits =
                value.replace(/[^0-9]/g, "");

            value = "PN-" + digits;
        }

        value = value.substring(0, 7);

        patientId.value = value;
    });
}

function initializePhoneFormatting() {
    const phone =
        document.getElementById("contact_number");

    if (!phone) {
        return;
    }

    phone.addEventListener("input", function () {
        phone.value =
            phone.value.replace(
                /[^0-9+\- ]/g,
                ""
            );
    });
}

function showFieldError(input, errorId, message) {
    if (!input) {
        return;
    }

    input.classList.add("input-error");

    const error =
        document.getElementById(errorId);

    if (error) {
        error.textContent = message;
    }
}

function clearValidationErrors() {
    document
        .querySelectorAll(".input-error")
        .forEach(function (input) {
            input.classList.remove("input-error");
        });

    document
        .querySelectorAll(".field-error")
        .forEach(function (error) {
            error.textContent = "";
        });
}

function confirmDelete(patientId, patientName) {
    const modal =
        document.getElementById("deleteModal");

    const nameElement =
        document.getElementById("deletePatientName");

    const deleteLink =
        document.getElementById("confirmDeleteLink");

    if (!modal || !deleteLink) {
        return;
    }

    if (nameElement) {
        nameElement.textContent = patientName;
    }

    deleteLink.href =
        "managePatients?action=delete&patient_id=" +
        encodeURIComponent(patientId);

    modal.classList.add("show");

    document.body.style.overflow = "hidden";
}

function closeDeleteModal() {
    const modal =
        document.getElementById("deleteModal");

    if (!modal) {
        return;
    }

    modal.classList.remove("show");

    document.body.style.overflow = "";
}

document.addEventListener("click", function (event) {
    const modal =
        document.getElementById("deleteModal");

    if (
        modal &&
        event.target === modal
    ) {
        closeDeleteModal();
    }
});

document.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
        closeDeleteModal();
    }
});

function clearSearch() {
    const input =
        document.querySelector(
            'input[name="keyword"]'
        );

    if (input) {
        input.value = "";

        if (input.form) {
            input.form.submit();
        }
    }
}

function closeAlert(id) {
    const alert =
        document.getElementById(id);

    if (!alert) {
        return;
    }

    alert.style.opacity = "0";
    alert.style.transform = "translateY(-8px)";

    setTimeout(function () {
        alert.remove();
    }, 250);
}

function initializeAutoHideAlerts() {
    const success =
        document.getElementById("successAlert");

    const error =
        document.getElementById("errorAlert");

    if (success) {
        setTimeout(function () {
            closeAlert("successAlert");
        }, 5000);
    }

    if (error) {
        setTimeout(function () {
            closeAlert("errorAlert");
        }, 7000);
    }
}

document.addEventListener("focusin", function (event) {
    if (
        event.target.matches(
            "input, textarea, select"
        )
    ) {
        event.target.classList.remove(
            "input-error"
        );
    }
});
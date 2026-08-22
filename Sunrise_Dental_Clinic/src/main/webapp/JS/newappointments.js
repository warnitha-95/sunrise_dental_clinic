document.addEventListener("DOMContentLoaded", function () {

    const MAX_TREATMENTS = 3;

    const treatmentCheckboxes = document.querySelectorAll(
        'input[name="treatmentIds"]'
    );

    const treatmentCountEl = document.getElementById("treatmentCount");
    const selectedTotalEl = document.getElementById("selectedTotal");
    const selectedTreatmentsEl = document.getElementById("selectedTreatments");
    const submitButton = document.getElementById("submitButton");
    const appointmentDateInput = document.getElementById("appointmentDate");

    // Prevent picking a date in the past
    if (appointmentDateInput) {
        const today = new Date();
        const yyyy = today.getFullYear();
        const mm = String(today.getMonth() + 1).padStart(2, "0");
        const dd = String(today.getDate()).padStart(2, "0");
        appointmentDateInput.min = `${yyyy}-${mm}-${dd}`;
    }

    function formatCurrency(amount) {
        return "LKR " + amount.toLocaleString("en-LK", {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
    }

    function refreshSelection() {
        const checked = Array.from(treatmentCheckboxes).filter(
            (cb) => cb.checked
        );

        // Update the counter
        if (treatmentCountEl) {
            treatmentCountEl.textContent = checked.length;
        }

        // Disable remaining unchecked boxes once the limit is reached
        const limitReached = checked.length >= MAX_TREATMENTS;
        treatmentCheckboxes.forEach((cb) => {
            if (!cb.checked) {
                cb.disabled = limitReached;
            }
        });

        // Rebuild the selected-treatments summary
        if (selectedTreatmentsEl) {
            selectedTreatmentsEl.innerHTML = "";

            if (checked.length === 0) {
                const placeholder = document.createElement("span");
                placeholder.className = "selected-placeholder";
                placeholder.textContent = "No treatments selected.";
                selectedTreatmentsEl.appendChild(placeholder);
            } else {
                checked.forEach((cb) => {
                    const name = cb.dataset.treatmentName || "Treatment";
                    const price = parseFloat(cb.dataset.treatmentPrice) || 0;

                    const item = document.createElement("div");
                    item.className = "selected-item";

                    const nameSpan = document.createElement("span");
                    nameSpan.textContent = name;

                    const priceSpan = document.createElement("span");
                    priceSpan.className = "item-price";
                    priceSpan.textContent = formatCurrency(price);

                    item.appendChild(nameSpan);
                    item.appendChild(priceSpan);
                    selectedTreatmentsEl.appendChild(item);
                });
            }
        }

        // Update running total
        const total = checked.reduce(
            (sum, cb) => sum + (parseFloat(cb.dataset.treatmentPrice) || 0),
            0
        );

        if (selectedTotalEl) {
            selectedTotalEl.textContent = formatCurrency(total);
        }
    }

    treatmentCheckboxes.forEach((cb) => {
        cb.addEventListener("change", refreshSelection);
    });

    // Initialize state on page load (handles browser autofill / back-button state)
    refreshSelection();

    const appointmentForm = document.getElementById("appointmentForm");

    if (appointmentForm) {
        appointmentForm.addEventListener("submit", function (e) {
            const checkedCount = Array.from(treatmentCheckboxes).filter(
                (cb) => cb.checked
            ).length;

            if (checkedCount < 1) {
                e.preventDefault();
                alert("Please select at least one treatment.");
                return;
            }

            if (checkedCount > MAX_TREATMENTS) {
                e.preventDefault();
                alert("You can select a maximum of " + MAX_TREATMENTS + " treatments.");
                return;
            }

            // Prevent double-submission
            if (submitButton) {
                submitButton.disabled = true;
                submitButton.innerHTML = "<span>...</span> Creating Appointment";
            }
        });
    }
});
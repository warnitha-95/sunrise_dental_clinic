document.addEventListener("DOMContentLoaded", function () {

    const searchInput = document.getElementById("appointmentSearch");
    const searchCount = document.getElementById("searchCount");
    const table = document.getElementById("appointmentsTable");

    if (!searchInput || !table) {
        return;
    }

    const tbody = table.querySelector("tbody");
    const allRows = Array.from(tbody.querySelectorAll("tr"));
    const totalCount = allRows.length;

    let noResultsRow = null;

    function ensureNoResultsRow() {
        if (!noResultsRow) {
            noResultsRow = document.createElement("tr");
            noResultsRow.className = "no-results-row";

            const colCount = table.querySelectorAll("thead th").length;
            const td = document.createElement("td");
            td.colSpan = colCount;
            td.innerHTML = '<i class="fas fa-magnifying-glass"></i>&nbsp; No appointments match your search.';

            noResultsRow.appendChild(td);
        }
        return noResultsRow;
    }

    function updateCount(visibleCount) {
        if (!searchCount) {
            return;
        }

        const query = searchInput.value.trim();

        if (!query) {
            searchCount.textContent = "";
            return;
        }

        searchCount.textContent = visibleCount + " of " + totalCount + " match" +
            (totalCount === 1 ? "" : "es");
    }

    function filterRows() {
        const query = searchInput.value.trim().toLowerCase();
        let visibleCount = 0;

        allRows.forEach((row) => {
            const text = row.textContent.toLowerCase();
            const matches = query === "" || text.includes(query);

            row.style.display = matches ? "" : "none";

            if (matches) {
                visibleCount++;
            }
        });

        const emptyRow = ensureNoResultsRow();

        if (visibleCount === 0 && query !== "") {
            if (!emptyRow.isConnected) {
                tbody.appendChild(emptyRow);
            }
        } else if (emptyRow.isConnected) {
            emptyRow.remove();
        }

        updateCount(visibleCount);
    }

    searchInput.addEventListener("input", filterRows);
});
package services;

import controller.DBConnect;
import model.appointment;
import model.dentist;
import model.treatment;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;

public class appointmentService {

    public ArrayList<dentist> getActiveDentists() {

        ArrayList<dentist> dentistList = new ArrayList<>();

        String sql =
                "SELECT dentist_id, dentist_name, specialization, status " +
                "FROM dentists " +
                "WHERE status = 'Active' " +
                "ORDER BY dentist_id ASC";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()
        ) {

            while (rs.next()) {

                dentist d = new dentist();

                d.setDentistId(rs.getInt("dentist_id"));
                d.setDentistName(rs.getString("dentist_name"));
                d.setSpecialization(rs.getString("specialization"));
                d.setStatus(rs.getString("status"));

                dentistList.add(d);
            }

            System.out.println("Active dentists loaded: " + dentistList.size());

        } catch (Exception e) {

            System.out.println("ERROR loading active dentists: " + e.getMessage());
            e.printStackTrace();
        }

        return dentistList;
    }

    public ArrayList<treatment> getActiveTreatments() {

        ArrayList<treatment> treatmentList = new ArrayList<>();

        String sql =
                "SELECT treatment_id, treatment_name, price_lkr, status " +
                "FROM treatments " +
                "WHERE status = 'Active' " +
                "ORDER BY treatment_id ASC";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()
        ) {

            while (rs.next()) {

                treatment t = new treatment();

                t.setTreatmentId(rs.getInt("treatment_id"));
                t.setTreatmentName(rs.getString("treatment_name"));
                t.setPriceLkr(rs.getBigDecimal("price_lkr"));
                t.setStatus(rs.getString("status"));

                treatmentList.add(t);
            }

            System.out.println("Active treatments loaded: " + treatmentList.size());

        } catch (Exception e) {

            System.out.println("ERROR loading active treatments: " + e.getMessage());
            e.printStackTrace();
        }

        return treatmentList;
    }

    public ArrayList<appointment> getAllAppointments() {

        ArrayList<appointment> appointmentList = new ArrayList<>();

        String sql =
                "SELECT a.appointment_id, a.appointment_number, a.patient_id, " +
                "a.patient_name, a.address, a.contact_number, a.dentist_id, " +
                "d.dentist_name, a.appointment_datetime, a.status, " +
                "GROUP_CONCAT(t.treatment_name SEPARATOR ', ') AS treatment_names, " +
                "COALESCE(SUM(t.price_lkr), 0) AS total_price " +
                "FROM appointments a " +
                "JOIN dentists d ON a.dentist_id = d.dentist_id " +
                "LEFT JOIN appointment_treatments at ON a.appointment_id = at.appointment_id " +
                "LEFT JOIN treatments t ON at.treatment_id = t.treatment_id " +
                "GROUP BY a.appointment_id " +
                "ORDER BY a.appointment_datetime DESC";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()
        ) {

            while (rs.next()) {

                appointment appt = new appointment();

                appt.setAppointmentId(rs.getInt("appointment_id"));
                appt.setAppointmentNumber(rs.getString("appointment_number"));
                appt.setPatientId(rs.getInt("patient_id"));
                appt.setPatientName(rs.getString("patient_name"));
                appt.setAddress(rs.getString("address"));
                appt.setContactNumber(rs.getString("contact_number"));
                appt.setDentistId(rs.getInt("dentist_id"));
                appt.setDentistName(rs.getString("dentist_name"));
                appt.setAppointmentDatetime(rs.getTimestamp("appointment_datetime"));
                appt.setStatus(rs.getString("status"));

                String treatmentNames = rs.getString("treatment_names");

                if (treatmentNames != null) {
                    appt.setTreatmentNames(Arrays.asList(treatmentNames.split(",\\s*")));
                }

                appt.setTotalPrice(rs.getBigDecimal("total_price"));

                appointmentList.add(appt);
            }

            System.out.println("Appointments loaded: " + appointmentList.size());

        } catch (Exception e) {

            System.out.println("ERROR loading appointments: " + e.getMessage());
            e.printStackTrace();
        }

        return appointmentList;
    }

    /**
     * Loads a single appointment (with its selected treatment ids) for
     * the Edit Appointment form. Includes the linked patient's gender.
     */
    public appointment getAppointmentById(int appointmentId) {

        appointment appt = null;

        String sql =
                "SELECT a.appointment_id, a.appointment_number, a.patient_id, a.patient_name, " +
                "a.address, a.contact_number, a.dentist_id, a.appointment_datetime, a.status, " +
                "p.gender " +
                "FROM appointments a " +
                "LEFT JOIN patients p ON a.patient_id = p.patient_id " +
                "WHERE a.appointment_id = ?";

        String treatmentSql =
                "SELECT treatment_id " +
                "FROM appointment_treatments " +
                "WHERE appointment_id = ?";

        try (Connection conn = DBConnect.getConnection()) {

            try (
                    PreparedStatement stmt = conn.prepareStatement(sql)
            ) {

                stmt.setInt(1, appointmentId);

                try (ResultSet rs = stmt.executeQuery()) {

                    if (rs.next()) {

                        appt = new appointment();

                        appt.setAppointmentId(rs.getInt("appointment_id"));
                        appt.setAppointmentNumber(rs.getString("appointment_number"));
                        appt.setPatientId(rs.getInt("patient_id"));
                        appt.setPatientName(rs.getString("patient_name"));
                        appt.setAddress(rs.getString("address"));
                        appt.setContactNumber(rs.getString("contact_number"));
                        appt.setDentistId(rs.getInt("dentist_id"));
                        appt.setAppointmentDatetime(rs.getTimestamp("appointment_datetime"));
                        appt.setStatus(rs.getString("status"));
                        appt.setGender(rs.getString("gender"));
                    }
                }
            }

            if (appt != null) {

                ArrayList<Integer> treatmentIds = new ArrayList<>();

                try (
                        PreparedStatement stmt = conn.prepareStatement(treatmentSql)
                ) {

                    stmt.setInt(1, appointmentId);

                    try (ResultSet rs = stmt.executeQuery()) {

                        while (rs.next()) {
                            treatmentIds.add(rs.getInt("treatment_id"));
                        }
                    }
                }

                appt.setTreatmentIds(treatmentIds);
            }

        } catch (Exception e) {

            System.out.println("ERROR loading appointment: " + e.getMessage());
            e.printStackTrace();
        }

        return appt;
    }

    /**
     * Loads appointment + dentist header details for the bill view
     * (no treatment list — use getTreatmentsForAppointment for that).
     */
    public appointment getAppointmentSummary(int appointmentId) {

        appointment appt = null;

        String sql =
                "SELECT a.appointment_id, a.appointment_number, a.patient_id, " +
                "a.patient_name, a.address, a.contact_number, a.dentist_id, " +
                "d.dentist_name, a.appointment_datetime, a.status " +
                "FROM appointments a " +
                "JOIN dentists d ON a.dentist_id = d.dentist_id " +
                "WHERE a.appointment_id = ?";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setInt(1, appointmentId);

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {

                    appt = new appointment();

                    appt.setAppointmentId(rs.getInt("appointment_id"));
                    appt.setAppointmentNumber(rs.getString("appointment_number"));
                    appt.setPatientId(rs.getInt("patient_id"));
                    appt.setPatientName(rs.getString("patient_name"));
                    appt.setAddress(rs.getString("address"));
                    appt.setContactNumber(rs.getString("contact_number"));
                    appt.setDentistId(rs.getInt("dentist_id"));
                    appt.setDentistName(rs.getString("dentist_name"));
                    appt.setAppointmentDatetime(rs.getTimestamp("appointment_datetime"));
                    appt.setStatus(rs.getString("status"));
                }
            }

        } catch (Exception e) {

            System.out.println("ERROR loading appointment summary: " + e.getMessage());
            e.printStackTrace();
        }

        return appt;
    }

    /**
     * Loads the itemized list of treatments (with price) billed under
     * a given appointment, for the printable bill.
     */
    public ArrayList<treatment> getTreatmentsForAppointment(int appointmentId) {

        ArrayList<treatment> treatmentList = new ArrayList<>();

        String sql =
                "SELECT t.treatment_id, t.treatment_name, t.price_lkr, t.status " +
                "FROM appointment_treatments at " +
                "JOIN treatments t ON at.treatment_id = t.treatment_id " +
                "WHERE at.appointment_id = ? " +
                "ORDER BY t.treatment_id ASC";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setInt(1, appointmentId);

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {

                    treatment t = new treatment();

                    t.setTreatmentId(rs.getInt("treatment_id"));
                    t.setTreatmentName(rs.getString("treatment_name"));
                    t.setPriceLkr(rs.getBigDecimal("price_lkr"));
                    t.setStatus(rs.getString("status"));

                    treatmentList.add(t);
                }
            }

        } catch (Exception e) {

            System.out.println("ERROR loading treatments for appointment: " + e.getMessage());
            e.printStackTrace();
        }

        return treatmentList;
    }

    /**
     * Updates an existing appointment's patient details, dentist, schedule,
     * status, and treatment selection. Also keeps the linked patients row
     * (including gender) in sync so changes here are reflected in
     * Manage Patients too. Replaces the appointment_treatments rows
     * entirely to match the new selection.
     */
    public boolean updateAppointment(appointment appt) {

        String updateSql =
                "UPDATE appointments " +
                "SET patient_name = ?, address = ?, contact_number = ?, " +
                "dentist_id = ?, appointment_datetime = ?, status = ? " +
                "WHERE appointment_id = ?";

        String updatePatientSql =
                "UPDATE patients " +
                "SET patient_name = ?, address = ?, contact_number = ?, gender = ? " +
                "WHERE patient_id = ?";

        String deleteTreatmentsSql =
                "DELETE FROM appointment_treatments " +
                "WHERE appointment_id = ?";

        String insertTreatmentSql =
                "INSERT INTO appointment_treatments " +
                "(appointment_id, treatment_id) " +
                "VALUES (?, ?)";

        Connection conn = null;

        try {

            conn = DBConnect.getConnection();

            conn.setAutoCommit(false);

            try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {

                stmt.setString(1, appt.getPatientName());
                stmt.setString(2, appt.getAddress());
                stmt.setString(3, appt.getContactNumber());
                stmt.setInt(4, appt.getDentistId());
                stmt.setTimestamp(5, appt.getAppointmentDatetime());
                stmt.setString(6, appt.getStatus());
                stmt.setInt(7, appt.getAppointmentId());

                int rows = stmt.executeUpdate();

                if (rows == 0) {
                    conn.rollback();
                    return false;
                }
            }

            if (appt.getPatientId() != null && appt.getPatientId() > 0) {

                try (PreparedStatement stmt = conn.prepareStatement(updatePatientSql)) {

                    stmt.setString(1, appt.getPatientName());
                    stmt.setString(2, appt.getAddress());
                    stmt.setString(3, appt.getContactNumber());
                    stmt.setString(
                            4,
                            (appt.getGender() != null && !appt.getGender().trim().isEmpty())
                                    ? appt.getGender().trim()
                                    : "Not specified"
                    );
                    stmt.setInt(5, appt.getPatientId());

                    stmt.executeUpdate();
                }
            }

            try (PreparedStatement stmt = conn.prepareStatement(deleteTreatmentsSql)) {

                stmt.setInt(1, appt.getAppointmentId());
                stmt.executeUpdate();
            }

            ArrayList<Integer> treatmentIds = new ArrayList<>(appt.getTreatmentIds());

            if (treatmentIds.isEmpty()) {
                conn.rollback();
                return false;
            }

            try (PreparedStatement stmt = conn.prepareStatement(insertTreatmentSql)) {

                for (Integer treatmentId : treatmentIds) {

                    stmt.setInt(1, appt.getAppointmentId());
                    stmt.setInt(2, treatmentId);
                    stmt.addBatch();
                }

                stmt.executeBatch();
            }

            conn.commit();

            System.out.println("Appointment updated successfully. ID: " + appt.getAppointmentId());

            return true;

        } catch (Exception e) {

            System.out.println("ERROR updating appointment: " + e.getMessage());
            e.printStackTrace();

            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception rollbackException) {
                    rollbackException.printStackTrace();
                }
            }

            return false;

        } finally {

            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception closeException) {
                    closeException.printStackTrace();
                }
            }
        }
    }

    /**
     * Deletes an appointment and its linked treatment rows.
     */
    public boolean deleteAppointment(int appointmentId) {

        String deleteTreatmentsSql =
                "DELETE FROM appointment_treatments " +
                "WHERE appointment_id = ?";

        String deleteAppointmentSql =
                "DELETE FROM appointments " +
                "WHERE appointment_id = ?";

        Connection conn = null;

        try {

            conn = DBConnect.getConnection();

            conn.setAutoCommit(false);

            try (PreparedStatement stmt = conn.prepareStatement(deleteTreatmentsSql)) {

                stmt.setInt(1, appointmentId);
                stmt.executeUpdate();
            }

            int rows;

            try (PreparedStatement stmt = conn.prepareStatement(deleteAppointmentSql)) {

                stmt.setInt(1, appointmentId);
                rows = stmt.executeUpdate();
            }

            if (rows == 0) {
                conn.rollback();
                return false;
            }

            conn.commit();

            System.out.println("Appointment deleted successfully. ID: " + appointmentId);

            return true;

        } catch (Exception e) {

            System.out.println("ERROR deleting appointment: " + e.getMessage());
            e.printStackTrace();

            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception rollbackException) {
                    rollbackException.printStackTrace();
                }
            }

            return false;

        } finally {

            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception closeException) {
                    closeException.printStackTrace();
                }
            }
        }
    }

    /**
     * Finds an existing patient by contact number, or creates a new one
     * if none exists — using the gender submitted on the appointment form.
     * Must be called using the same connection/transaction as the
     * appointment insert so both succeed or roll back together.
     */
    private int findOrCreatePatientId(
            Connection conn,
            appointment appt)
            throws Exception {

        String findSql =
                "SELECT patient_id " +
                "FROM patients " +
                "WHERE contact_number = ? " +
                "LIMIT 1";

        try (PreparedStatement findStmt = conn.prepareStatement(findSql)) {

            findStmt.setString(1, appt.getContactNumber());

            try (ResultSet rs = findStmt.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt("patient_id");
                }
            }
        }

        String insertSql =
                "INSERT INTO patients " +
                "(patient_name, address, contact_number, gender, status) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (
                PreparedStatement insertStmt =
                        conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS)
        ) {

            insertStmt.setString(1, appt.getPatientName());
            insertStmt.setString(2, appt.getAddress());
            insertStmt.setString(3, appt.getContactNumber());
            insertStmt.setString(
                    4,
                    (appt.getGender() != null && !appt.getGender().trim().isEmpty())
                            ? appt.getGender().trim()
                            : "Not specified"
            );
            insertStmt.setString(5, "Active");

            insertStmt.executeUpdate();

            try (ResultSet keys = insertStmt.getGeneratedKeys()) {

                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }

        throw new Exception("Failed to find or create patient record.");
    }

    public boolean createAppointment(appointment appt) {

        String appointmentSql =
                "INSERT INTO appointments " +
                "(appointment_number, patient_id, patient_name, address, contact_number, dentist_id, appointment_datetime, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        String treatmentSql =
                "INSERT INTO appointment_treatments " +
                "(appointment_id, treatment_id) " +
                "VALUES (?, ?)";

        Connection conn = null;

        try {

            conn = DBConnect.getConnection();

            conn.setAutoCommit(false);

            int patientId = findOrCreatePatientId(conn, appt);

            int appointmentId;

            String appointmentNumber = "APT-" + System.currentTimeMillis();

            try (
                    PreparedStatement stmt =
                            conn.prepareStatement(appointmentSql, PreparedStatement.RETURN_GENERATED_KEYS)
            ) {

                stmt.setString(1, appointmentNumber);
                stmt.setInt(2, patientId);
                stmt.setString(3, appt.getPatientName());
                stmt.setString(4, appt.getAddress());
                stmt.setString(5, appt.getContactNumber());
                stmt.setInt(6, appt.getDentistId());
                stmt.setTimestamp(7, appt.getAppointmentDatetime());
                stmt.setString(8, "Scheduled");

                int rows = stmt.executeUpdate();

                if (rows == 0) {
                    conn.rollback();
                    return false;
                }

                try (ResultSet keys = stmt.getGeneratedKeys()) {

                    if (!keys.next()) {
                        conn.rollback();
                        return false;
                    }

                    appointmentId = keys.getInt(1);
                }
            }

            ArrayList<Integer> treatmentIds = new ArrayList<>(appt.getTreatmentIds());

            if (treatmentIds.isEmpty()) {
                conn.rollback();
                return false;
            }

            try (PreparedStatement stmt = conn.prepareStatement(treatmentSql)) {

                for (Integer treatmentId : treatmentIds) {

                    stmt.setInt(1, appointmentId);
                    stmt.setInt(2, treatmentId);
                    stmt.addBatch();
                }

                stmt.executeBatch();
            }

            conn.commit();

            System.out.println(
                    "Appointment created successfully. ID: " + appointmentId
                    + ", Patient ID: " + patientId
            );

            return true;

        } catch (Exception e) {

            System.out.println("ERROR creating appointment: " + e.getMessage());
            e.printStackTrace();

            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception rollbackException) {
                    rollbackException.printStackTrace();
                }
            }

            return false;

        } finally {

            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception closeException) {
                    closeException.printStackTrace();
                }
            }
        }
    }
}
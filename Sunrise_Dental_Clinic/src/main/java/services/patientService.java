package services;

import controller.DBConnect;
import model.patient;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;

public class patientService {

    public ArrayList<patient> getAllPatients() {

        ArrayList<patient> patientList = new ArrayList<>();

        String sql =
                "SELECT patient_id, patient_name, address, " +
                "contact_number, gender, registered_datetime, status " +
                "FROM patients " +
                "ORDER BY patient_id DESC";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()
        ) {

            while (rs.next()) {

                patient pat = new patient();

                pat.setPatient_id(
                        rs.getInt("patient_id")
                );

                pat.setPatient_name(
                        rs.getString("patient_name")
                );

                pat.setAddress(
                        rs.getString("address")
                );

                pat.setContact_number(
                        rs.getString("contact_number")
                );

                pat.setGender(
                        rs.getString("gender")
                );

                pat.setRegister_datetime(
                        rs.getTimestamp("registered_datetime")
                );

                pat.setStatus(
                        rs.getString("status")
                );

                patientList.add(pat);
            }

            System.out.println(
                    "Patients loaded from database: "
                    + patientList.size()
            );

        } catch (Exception e) {

            System.out.println(
                    "ERROR loading patients: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return patientList;
    }


    public ArrayList<patient> searchPatients(String keyword) {

        ArrayList<patient> patientList = new ArrayList<>();

        String sql =
                "SELECT patient_id, patient_name, address, " +
                "contact_number, gender, registered_datetime, status " +
                "FROM patients " +
                "WHERE CAST(patient_id AS CHAR) LIKE ? " +
                "OR patient_name LIKE ? " +
                "OR contact_number LIKE ? " +
                "ORDER BY patient_id DESC";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            String search = "%" + keyword.trim() + "%";

            stmt.setString(1, search);
            stmt.setString(2, search);
            stmt.setString(3, search);

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {

                    patient pat = new patient();

                    pat.setPatient_id(
                            rs.getInt("patient_id")
                    );

                    pat.setPatient_name(
                            rs.getString("patient_name")
                    );

                    pat.setAddress(
                            rs.getString("address")
                    );

                    pat.setContact_number(
                            rs.getString("contact_number")
                    );

                    pat.setGender(
                            rs.getString("gender")
                    );

                    pat.setRegister_datetime(
                            rs.getTimestamp("registered_datetime")
                    );

                    pat.setStatus(
                            rs.getString("status")
                    );

                    patientList.add(pat);
                }
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR searching patients: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return patientList;
    }


    public patient getPatientById(int patientId) {

        patient pat = null;

        String sql =
                "SELECT patient_id, patient_name, address, " +
                "contact_number, gender, registered_datetime, status " +
                "FROM patients " +
                "WHERE patient_id = ?";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setInt(1, patientId);

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {

                    pat = new patient();

                    pat.setPatient_id(
                            rs.getInt("patient_id")
                    );

                    pat.setPatient_name(
                            rs.getString("patient_name")
                    );

                    pat.setAddress(
                            rs.getString("address")
                    );

                    pat.setContact_number(
                            rs.getString("contact_number")
                    );

                    pat.setGender(
                            rs.getString("gender")
                    );

                    pat.setRegister_datetime(
                            rs.getTimestamp("registered_datetime")
                    );

                    pat.setStatus(
                            rs.getString("status")
                    );
                }
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR getting patient: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return pat;
    }


    public boolean addPatient(patient pat) {

        String sql =
                "INSERT INTO patients " +
                "(patient_name, address, contact_number, gender, status) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setString(
                    1,
                    pat.getPatient_name()
            );

            stmt.setString(
                    2,
                    pat.getAddress()
            );

            stmt.setString(
                    3,
                    pat.getContact_number()
            );

            stmt.setString(
                    4,
                    pat.getGender()
            );

            String status = pat.getStatus();

            if (status == null || status.trim().isEmpty()) {
                status = "Active";
            }

            stmt.setString(
                    5,
                    status
            );

            int rows = stmt.executeUpdate();

            return rows > 0;

        } catch (Exception e) {

            System.out.println(
                    "ERROR adding patient: "
                    + e.getMessage()
            );

            e.printStackTrace();

            return false;
        }
    }


    public boolean updatePatient(patient pat) {

        String sql =
                "UPDATE patients SET " +
                "patient_name = ?, " +
                "address = ?, " +
                "contact_number = ?, " +
                "gender = ?, " +
                "status = ? " +
                "WHERE patient_id = ?";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setString(
                    1,
                    pat.getPatient_name()
            );

            stmt.setString(
                    2,
                    pat.getAddress()
            );

            stmt.setString(
                    3,
                    pat.getContact_number()
            );

            stmt.setString(
                    4,
                    pat.getGender()
            );

            stmt.setString(
                    5,
                    pat.getStatus()
            );

            stmt.setInt(
                    6,
                    pat.getPatient_id()
            );

            int rows = stmt.executeUpdate();

            return rows > 0;

        } catch (Exception e) {

            System.out.println(
                    "ERROR updating patient: "
                    + e.getMessage()
            );

            e.printStackTrace();

            return false;
        }
    }


    public boolean deletePatient(int patientId) {

        String sql =
                "DELETE FROM patients " +
                "WHERE patient_id = ?";

        try (
                Connection conn = DBConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setInt(1, patientId);

            int rows = stmt.executeUpdate();

            return rows > 0;

        } catch (Exception e) {

            System.out.println(
                    "ERROR deleting patient: "
                    + e.getMessage()
            );

            e.printStackTrace();

            return false;
        }
    }
}
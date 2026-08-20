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

        String sql = "SELECT patient_id, patient_name, address, " +
                     "contact_number, gender, registered_datetime, status " +
                     "FROM patients ORDER BY registered_datetime DESC";

        try (
            Connection conn = DBConnect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()
        ) {

            while (rs.next()) {

                patient pat = new patient();

                pat.setPatient_id(
                        rs.getString("patient_id")
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
                "WHERE patient_id LIKE ? " +
                "OR patient_name LIKE ? " +
                "OR contact_number LIKE ? " +
                "ORDER BY registered_datetime DESC";

        try (
            Connection conn = DBConnect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            String search = "%" + keyword + "%";

            stmt.setString(1, search);
            stmt.setString(2, search);
            stmt.setString(3, search);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {

                patient pat = new patient();

                pat.setPatient_id(
                        rs.getString("patient_id")
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

        } catch (Exception e) {
            e.printStackTrace();
        }

        return patientList;
    }


    public patient getPatientById(String patientId) {

        patient pat = null;

        String sql =
                "SELECT patient_id, patient_name, address, " +
                "contact_number, gender, registered_datetime, status " +
                "FROM patients WHERE patient_id = ?";

        try (
            Connection conn = DBConnect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setString(1, patientId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {

                pat = new patient();

                pat.setPatient_id(
                        rs.getString("patient_id")
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

        } catch (Exception e) {
            e.printStackTrace();
        }

        return pat;
    }

    
    public boolean addPatient(patient pat) {

        String sql =
                "INSERT INTO patients " +
                "(patient_id, patient_name, address, contact_number, " +
                "gender, registered_datetime, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (
            Connection conn = DBConnect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setString(1, pat.getPatient_id());
            stmt.setString(2, pat.getPatient_name());
            stmt.setString(3, pat.getAddress());
            stmt.setString(4, pat.getContact_number());
            stmt.setString(5, pat.getGender());

            if (pat.getRegister_datetime() == null) {
                stmt.setTimestamp(
                        6,
                        new Timestamp(System.currentTimeMillis())
                );
            } else {
                stmt.setTimestamp(
                        6,
                        pat.getRegister_datetime()
                );
            }

            stmt.setString(7, pat.getStatus());

            int rows = stmt.executeUpdate();

            return rows > 0;

        } catch (Exception e) {

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

            stmt.setString(1, pat.getPatient_name());
            stmt.setString(2, pat.getAddress());
            stmt.setString(3, pat.getContact_number());
            stmt.setString(4, pat.getGender());
            stmt.setString(5, pat.getStatus());
            stmt.setString(6, pat.getPatient_id());

            int rows = stmt.executeUpdate();

            return rows > 0;

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }



    public boolean deletePatient(String patientId) {

        String sql =
                "DELETE FROM patients WHERE patient_id = ?";

        try (
            Connection conn = DBConnect.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setString(1, patientId);

            int rows = stmt.executeUpdate();

            return rows > 0;

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }
}
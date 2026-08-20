package model;

import java.sql.Timestamp;

public class patient {

    private String patient_id;
    private String patient_name;
    private String address;
    private String contact_number;
    private String gender;
    private Timestamp register_datetime;
    private String status;

    // Default constructor
    public patient() {
    }

    // Parameterized constructor
    public patient(
            String patient_id,
            String patient_name,
            String address,
            String contact_number,
            String gender,
            Timestamp register_datetime,
            String status) {

        this.patient_id = patient_id;
        this.patient_name = patient_name;
        this.address = address;
        this.contact_number = contact_number;
        this.gender = gender;
        this.register_datetime = register_datetime;
        this.status = status;
    }

    public String getPatient_id() {
        return patient_id;
    }

    public void setPatient_id(String patient_id) {
        this.patient_id = patient_id;
    }

    public String getPatient_name() {
        return patient_name;
    }

    public void setPatient_name(String patient_name) {
        this.patient_name = patient_name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getContact_number() {
        return contact_number;
    }

    public void setContact_number(String contact_number) {
        this.contact_number = contact_number;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Timestamp getRegister_datetime() {
        return register_datetime;
    }

    public void setRegister_datetime(Timestamp register_datetime) {
        this.register_datetime = register_datetime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "patient{" +
                "patient_id='" + patient_id + '\'' +
                ", patient_name='" + patient_name + '\'' +
                ", address='" + address + '\'' +
                ", contact_number='" + contact_number + '\'' +
                ", gender='" + gender + '\'' +
                ", register_datetime=" + register_datetime +
                ", status='" + status + '\'' +
                '}';
    }
}
package model;

public class patient {

    private int patient_id;
    private String patient_name;
    private String address;
    private String contact_number;
    private String gender;
    private java.sql.Timestamp register_datetime;
    private String status;

    public patient() {
    }

    public patient(String patient_name,
                   String address,
                   String contact_number,
                   String gender,
                   String status) {

        this.patient_name = patient_name;
        this.address = address;
        this.contact_number = contact_number;
        this.gender = gender;
        this.status = status;
    }

    public int getPatient_id() {
        return patient_id;
    }

    public void setPatient_id(int patient_id) {
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

    public java.sql.Timestamp getRegister_datetime() {
        return register_datetime;
    }

    public void setRegister_datetime(java.sql.Timestamp register_datetime) {
        this.register_datetime = register_datetime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
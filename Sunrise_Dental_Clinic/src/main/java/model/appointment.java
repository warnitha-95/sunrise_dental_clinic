package model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class appointment {

    private int appointmentId;
    private String appointmentNumber;
    private Integer patientId;
    private String patientName;
    private String address;
    private String contactNumber;
    private String gender;
    private int dentistId;
    private String dentistName;
    private Timestamp appointmentDatetime;
    private String status;
    private List<Integer> treatmentIds;
    private List<String> treatmentNames;
    private BigDecimal totalPrice;

    public appointment() {
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public String getAppointmentNumber() {
        return appointmentNumber;
    }

    public void setAppointmentNumber(String appointmentNumber) {
        this.appointmentNumber = appointmentNumber;
    }

    public Integer getPatientId() {
        return patientId;
    }

    public void setPatientId(Integer patientId) {
        this.patientId = patientId;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public int getDentistId() {
        return dentistId;
    }

    public void setDentistId(int dentistId) {
        this.dentistId = dentistId;
    }

    public String getDentistName() {
        return dentistName;
    }

    public void setDentistName(String dentistName) {
        this.dentistName = dentistName;
    }

    public Timestamp getAppointmentDatetime() {
        return appointmentDatetime;
    }

    public void setAppointmentDatetime(Timestamp appointmentDatetime) {
        this.appointmentDatetime = appointmentDatetime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<Integer> getTreatmentIds() {
        return treatmentIds;
    }

    public void setTreatmentIds(List<Integer> treatmentIds) {
        this.treatmentIds = treatmentIds;
    }

    public List<String> getTreatmentNames() {
        return treatmentNames;
    }

    public void setTreatmentNames(List<String> treatmentNames) {
        this.treatmentNames = treatmentNames;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
}
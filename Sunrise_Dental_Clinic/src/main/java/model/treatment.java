package model;

import java.math.BigDecimal;

public class treatment {

    private int treatmentId;
    private String treatmentName;
    private BigDecimal priceLkr;
    private String status;

    public treatment() {
    }

    public treatment(int treatmentId, String treatmentName,
                     BigDecimal priceLkr, String status) {
        this.treatmentId = treatmentId;
        this.treatmentName = treatmentName;
        this.priceLkr = priceLkr;
        this.status = status;
    }

    public int getTreatmentId() {
        return treatmentId;
    }

    public void setTreatmentId(int treatmentId) {
        this.treatmentId = treatmentId;
    }

    public String getTreatmentName() {
        return treatmentName;
    }

    public void setTreatmentName(String treatmentName) {
        this.treatmentName = treatmentName;
    }

    public BigDecimal getPriceLkr() {
        return priceLkr;
    }

    public void setPriceLkr(BigDecimal priceLkr) {
        this.priceLkr = priceLkr;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
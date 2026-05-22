package model;

public class BantuanRule {
    private String ruleKey;
    private String ruleName;
    private double weight;

    public BantuanRule() {}

    public BantuanRule(String ruleKey, String ruleName, double weight) {
        this.ruleKey = ruleKey;
        this.ruleName = ruleName;
        this.weight = weight;
    }

    public String getRuleKey() {
        return ruleKey;
    }

    public void setRuleKey(String ruleKey) {
        this.ruleKey = ruleKey;
    }

    public String getRuleName() {
        return ruleName;
    }

    public void setRuleName(String ruleName) {
        this.ruleName = ruleName;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }
}

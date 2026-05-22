# Implementation Plan: Bantuan Module Enhancement

## Overview
This plan outlines the implementation of eligibility-based aid distribution improvements for the MyKampung_V2 system. The enhancements focus on: 1) Accurate aid allocation through eligibility scoring, 2) Improved decision-making tools for AJK/Ketua Kampung, and 3) Real-world workflow alignment.

## Phase 1: Eligibility Scoring Foundation (Weeks 1-3)
*Objective: Implement core eligibility calculation engine*

### Tasks:
- [ ] Extend `PermohonanBantuan` model:
  - Add `eligibilityScore` (Double, 0-100)
  - Add `eligibilityTier` (Enum: TINGGI, SEDERHANA, RENDAH)
  - Add `eligibilityFlags` (List<String> for flags like PENDAPATAN_RENDAH, IBU_TUNGGAL)
  - Add `calculateEligibilityScore()` method with configurable rules
- [ ] Create `EligibilityService` class:
  - Rule engine for scoring based on:
    - Pendapatan vs. KKM poverty line (configurable thresholds)
    - Status keluarga (ibu tunggal, okupat, handicap, etc.)
    - Bilangan dependen
    - Status pekerjaan
  - Configurable rule weights (stored in database)
- [ ] Database changes:
  - Add columns to `permohonan_bantuan` table:
    - `eligibility_score` DOUBLE
    - `eligibility_tier` VARCHAR(20)
    - `eligibility_flags` TEXT (JSON array)
- [ ] Admin interface for rule configuration:
  - Page to set income thresholds per aid type
  - Weight configuration for eligibility factors
  - Flag definition management

### Dependencies:
- None (foundational work)
### Estimated Effort: 8 story points

## Phase 2: Decision Support Interface (Weeks 4-6)
*Objective: Enhance AJK/Ketua Kampung interface with eligibility insights*

### Tasks:
- [ ] Modify detail modals in all bantuan JSP files:
  - Add eligibility score progress bar (green/yellow/red)
  - Display eligibility tier with color coding
  - Show eligibility flags with icons (e.g., 📉 for low income, 👩‍👧‍👦 for single parent)
- [ ] Implement eligibility-based action recommendations:
  - Score ≥80: "Cadangan Lulus" button with explanation
  - Score 40-79: "Perlu Semakan Mendalam" with flag highlights
  - Score <40: "Cadangan Tolak" with primary reason
- [ ] Add eligibility checklist for manual review:
  - Auto-generated checklist based on flags (e.g., "Verifikasi dokumen pendapatan", "Semakan status keluarga")
  - Ability to add custom notes per checklist item
- [ ] Update status badges to incorporate eligibility:
  - New status: "MENUNGGU_ELIGIBILITY" for scores 40-79
  - Visual distinction in lists (subtle background color)

### Dependencies:
- Phase 1 completion
### Estimated Effort: 5 story points

## Phase 3: Workflow Automation & Notifications (Weeks 7-9)
*Objective: Implement intelligent workflow routing and proactive communication*

### Tasks:
- [ ] Implement automatic routing rules:
  - Score ≥85: Auto-route to "Cadangan Lulus" queue (requires AJK confirmation)
  - Score <35: Auto-route to "Tolak Auto" queue with notification template
  - Score 35-84: Standard AJK review queue
- [ ] Develop notification service:
  - SMS/WhatsApp templates for:
    - Document requests (based on missing flags)
    - Eligibility status updates
    - Final decision notifications
  - Integration with existing notification system (if any) or new Twilio/Vonage adapter
- [ ] Enhance audit trail:
  - Log all eligibility score calculations
  - Record manual overrides with justification
  - Track timestamp of each workflow stage transition
- [ ] Add "Kelakuan Semakan" eligibility report:
  - Monthly report showing:
    - Distribution of eligibility tiers
    - Common rejection reasons
    - Processing time by tier
    - AJK override statistics

### Dependencies:
- Phases 1-2 completion
### Estimated Effort: 6 story points

## Phase 4: Real-World Workflow Enforcement (Weeks 10-12)
*Objective: Ensure system enforces proper aid distribution procedures*

### Tasks:
- [ ] Implement workflow state machine:
  - Define valid state transitions:
    BARU → SEMASUK_DOKUMEN → PENILAIAN_ELIGIBILITAS → REVIEW_AJK → REVIEW_KETUA → LULUS/TOLAK
  - Prevent skipping states (e.g., cannot go from BARU directly to LULUS)
  - Ajk can only advance to REVIEW_KETUA after eligibility review complete
- [ ] Create eligibility dashboard for supervisors:
  - Real-time view of:
    - Applications by eligibility tier
    - Bottlenecks in workflow
    - AJK performance metrics (review time, override rate)
  - Export capabilities for monthly reporting
- [ ] Prepare data migration script:
  - Calculate eligibility scores for existing applications
  - Set appropriate tiers based on historical data
- [ ] User acceptance testing:
  - Test scenarios with AJK/Ketua Kampung representatives
  - Validate against real-world eligibility cases
  - Refine scoring rules based on feedback

### Dependencies:
- Phases 1-3 completion
### Estimated Effort: 4 story points

## Timeline Summary
| Phase | Duration | Key Deliverables |
|-------|----------|------------------|
| 1 | Weeks 1-3 | Eligibility scoring engine, DB schema, rule config UI |
| 2 | Weeks 4-6 | Enhanced decision interface, eligibility flags display |
| 3 | Weeks 7-9 | Automated routing, notifications, audit trail |
| 4 | Weeks 10-12 | Workflow enforcement, supervisor dashboard, UAT |

## Resource Requirements
- **Backend Developer**: 2 persons (Phases 1, 3, 4)
- **Frontend Developer**: 1 person (Phases 2, 4)
- **Database Admin**: 0.5 person (Phase 1, 4)
- **QA/Tester**: 0.5 person (All phases, concentrated in Phase 4)
- **Domain Expert** (AJK representative): Part-time for validation (Phases 2, 4)

## Risks & Mitigation
| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Inaccurate eligibility scoring | Medium | High | Pilot testing with historical data; adjustable rules; manual override capability |
| AJK resistance to new workflow | Medium | Medium | Involve AJK in design; provide training; show time-saving benefits |
| Performance impact on eligibility calc | Low | Medium | Cache scores; async calculation for bulk operations; index new DB columns |
| Notification delivery failures | Low | Low | Fallback to in-app notifications; delivery status tracking |
| Data migration errors | Low | High | Backup before migration; test on staging; rollback procedure |

## Success Metrics
1. **Accuracy**: 90% of aid allocations match eligibility tier recommendations (measured via post-implementation audit)
2. **Efficiency**: 30% reduction in average processing time per application
3. **User Satisfaction**: ≥4/5 rating from AJK/Ketua Kampung on new decision tools (survey)
4. **Compliance**: 100% of applications follow enforced workflow stages (system enforcement)
5. **Transparency**: 95% of applicants receive eligibility status update within 24hrs of status change

## Notes
- All changes maintain backward compatibility with existing data
- Eligibility rules are configurable without code changes (via admin interface)
- Priority given to enhancing existing JSP files rather than full rewrite
- Integration points designed for future connection with eKasih or similar government systems
- Mobile responsiveness maintained in all UI enhancements

--- 
*Prepared for MyKampung_V2 enhancement initiative*
*Next step: Review with technical lead and domain experts to refine scoring criteria*
# Universal Data Handling Baseline
# Scope: GDPR/privacy baseline that applies to ALL companies using this marketing engine.
# Usage: Always loaded. Industry-specific data handling modules (saas-gdpr.md, etc.)
# extend this baseline. Company-specific data fields, retention periods, and contact info
# are configured per tenant.

## 1. Data Collection Principles

### 1.1 Data Minimization (GDPR Article 5(1)(c))

- Collect ONLY data fields that have a specific, documented purpose
- Before adding any new data field, document: what data, why needed, legal basis, retention period
- Default position: do NOT collect unless a specific, documented need exists

### 1.2 Purpose Limitation (GDPR Article 5(1)(b))

- Data collected for marketing purposes is used ONLY for marketing
- Data is NEVER used for: financial analysis, surveillance, identity verification, or sale to third parties
- If a new use case arises, the legal basis must be re-evaluated before proceeding

### 1.3 Storage Minimization

- Store data in encrypted databases only (not in flat files, spreadsheets, or developer laptops)
- No copies of lead/customer data in email, chat logs, or shared documents
- Cache data (Redis or similar) should have TTL set. Never persist indefinitely
- Workflow execution logs containing personal data should be purged on a 30-day cycle

### 1.4 Access Minimization

- Limit direct database access to authorized personnel only
- Automation workflows access data through dedicated service accounts with minimal privileges
- Bots and public-facing systems should have zero access to lead/CRM data unless specifically required

## 2. Legal Basis for Collection

### 2.1 Legitimate Interest (GDPR Article 6(1)(f))

Valid for: processing publicly available data (social media profiles, public posts) for community engagement and marketing purposes.

**Required balancing test:**
- Document {COMPANY_NAME}'s legitimate interest
- Document data subjects' interests and rights
- Confirm processing is proportionate to the marketing purpose
- Confirm users are not adversely affected
- Confirm opt-out mechanism exists

### 2.2 Explicit Consent (GDPR Article 6(1)(a))

Required for:
- Email marketing (double opt-in)
- Cookie-based website tracking
- Any data collection beyond publicly available information

Consent must be: freely given, specific, informed, unambiguous (affirmative action, not pre-ticked boxes), and withdrawable.

### 2.3 Legal Obligation (GDPR Article 6(1)(c))

Applied to: retention of consent records (proof of opt-in), retention of unsubscribe records, data retained for legal or regulatory compliance.

## 3. Standard Retention Periods

These are baseline recommendations. Adjust per industry requirements and legal counsel.

| Data Category | Retention Period | Deletion Trigger | Deletion Method |
|--------------|-----------------|------------------|-----------------|
| Social media engagement data (active) | 12 months from last interaction | No engagement for 12 months | Automated deletion job |
| Social media engagement data (deletion requested) | Deleted within 30 days of request | Data subject request | Manual + automated verification |
| Cached content (tweets, posts) | 90 days | Time-based | Automated deletion job |
| Email marketing data (active) | Until unsubscribe | User unsubscribes | CRM removes from active lists |
| Email marketing data (unsubscribed) | 30 days after unsubscribe | Grace period | Automated CRM cleanup |
| Consent records | Duration of relationship + 3 years | End of relationship + 3 years | Manual review |
| Bot interaction logs | 90 days | Time-based | Automated log rotation |
| Website analytics | Per analytics tool settings | Tool-managed | Tool-managed |
| Workflow execution logs | 30 days | Time-based | Automated log purge |
| Database backups | 90 days (rolling) | Time-based | Old backups overwritten |

### 3.1 Automated Deletion

- Run a scheduled job (cron or workflow) weekly to enforce retention limits
- Deletion jobs log the COUNT of records deleted (not the data itself) for audit
- Process any pending data deletion requests

## 4. User Rights

### 4.1 Right of Access (GDPR Article 15)

Any person can request to know what data {COMPANY_NAME} holds about them.
- How to request: Email {PRIVACY_EMAIL}
- Response time: Within 30 days
- Provide: human-readable summary of all data held

### 4.2 Right to Erasure (GDPR Article 17)

Any person can request deletion of their data.
- How to request: Email {PRIVACY_EMAIL} with request "data deletion"
- Response time: Data deleted within 30 days. Confirmation sent.
- What is deleted: All personal records across all systems
- What is retained: Anonymized aggregate statistics only

### 4.3 Right to Rectification (GDPR Article 16)

Any person can request correction of inaccurate data.
- How to request: Email {PRIVACY_EMAIL}
- Response time: Within 30 days

### 4.4 Right to Data Portability (GDPR Article 20)

Any person can request their data in a machine-readable format.
- Format: JSON export
- Response time: Within 30 days

### 4.5 Right to Object to Profiling (GDPR Article 21)

Any person can object to automated profiling (lead scoring, tier assignment).
- Effect: Scoring disabled. Only manual interactions.
- Response time: Within 30 days

### 4.6 Right Not to Be Subject to Automated Decision-Making (GDPR Article 22)

If the system uses automated lead scoring and engagement assignment, provide the right to opt out even if the processing does not produce "legal effects."
- How to opt out: Email {PRIVACY_EMAIL} or reply "opt out" / "stop" to any automated engagement
- Effect: Immediately removed from automated engagement. Data can be deleted on request.

## 5. Third-Party Data Sharing

### 5.1 Principles

- {COMPANY_NAME} does NOT sell personal data to any third party
- {COMPANY_NAME} does NOT share lead data with advertisers, data brokers, or marketing partners
- Lead data is NEVER included in public analytics, blog posts, or social media content (aggregate, anonymized metrics only)

### 5.2 Documentation Requirements

For each third-party tool that receives data, document:
- What data is shared
- Purpose of sharing
- Whether a Data Processing Agreement (DPA) is required
- Whether the service is self-hosted (no third-party transfer) or cloud-hosted

### 5.3 AI Model Data Handling

When feeding data to AI APIs for content generation:
- Strip personally identifiable information before including in prompts
- Never include: email addresses, financial data, lead scores, or engagement history in prompts
- Review the AI provider's data retention policy. Confirm API data is not used for model training

## 6. Incident Response for Data Breaches

### 6.1 Definition

A data breach occurs when personal data is: accessed by unauthorized persons, altered without authorization, or lost/destroyed without authorization.

### 6.2 Immediate Response (0-24 hours)

1. Contain: Isolate the affected system
2. Assess: What data was accessed, how many records, sensitivity level
3. Credential rotation: Rotate ALL credentials for affected systems
4. Preserve evidence: Capture logs, screenshots, system state before making changes
5. Notify {REVIEW_AUTHORITY}

### 6.3 Notification Requirements (24-72 hours)

**GDPR (EU/EEA residents affected):**
- Notify relevant Data Protection Authority within 72 hours (Article 33)
- If high risk to individuals, notify affected individuals without undue delay (Article 34)
- Include: nature of breach, data categories, approximate record count, likely consequences, measures taken

**Other jurisdictions:** Consult legal counsel for jurisdiction-specific requirements (CCPA, UK GDPR, etc.).

### 6.4 Post-Incident (1-4 weeks)

1. Root cause analysis
2. Remediation of vulnerability
3. Written incident report
4. Policy update based on lessons learned
5. Public communication if required

### 6.5 Breach Severity Classification

| Severity | Criteria | Response |
|----------|---------|----------|
| LOW | Non-personal data exposed | Internal investigation only |
| MEDIUM | Limited personal data, small record count (<100) | Internal investigation, DPA notification if required |
| HIGH | Large record count (>100) or sensitive data | Full incident response, DPA notification within 72 hours |
| CRITICAL | Sensitive personal data combined with identity data, or ongoing unauthorized access | Full response, immediate DPA notification, system shutdown |

## 7. Cross-Border Data Transfer

### 7.1 Requirements

- If processing data of EU/EEA residents and storing outside EU/EEA, this constitutes an international transfer under GDPR Chapter V
- Ensure appropriate transfer mechanisms: adequacy decisions, Standard Contractual Clauses (SCCs), or binding corporate rules
- Encryption in transit (TLS) and at rest (disk encryption) for all personal data

### 7.2 Cloud Service Transfers

For each cloud service, document:
- Where data is processed/stored geographically
- What transfer mechanism applies (DPA, SCCs, adequacy decision)
- Whether prompts sent to AI APIs contain personal data

## 8. Policy Maintenance

- Review this policy quarterly or after any data breach, whichever comes first
- Document any new data collection activity before implementation
- Document any new third-party tool integration before deployment

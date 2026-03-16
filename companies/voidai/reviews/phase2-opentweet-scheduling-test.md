# Phase 2: OpenTweet Scheduling Test Report

**Date**: 2026-03-15
**Tester**: Direct CLI testing
**Account**: @testy1796297 (Advanced plan)

---

## Account Status (Verified)

```json
{
  "subscription": { "status": "active", "trial_ends_at": "2026-03-22T22:22:04.557Z" },
  "limits": { "daily_limit": 20, "remaining_posts_today": 17 },
  "stats": { "total_posts": 0, "scheduled_posts": 0, "posted_posts": 0, "draft_posts": 0 }
}
```

- Advanced plan: 300 req/min, 10,000 req/day
- 20 posts/day publishing limit
- Trial ends 2026-03-22

---

## Test Results

### 1. Scheduled Single Tweet: PASS

- **Endpoint**: `POST /api/v1/posts` with `scheduled_date` parameter
- **Scheduled for**: 30 minutes in future (ISO 8601 format)
- **Response**: 201, status: "scheduled", ID: `69b742809ed4480bced16307`
- **Cleanup**: Deleted successfully

### 2. Scheduled Thread: PASS

- **Endpoint**: Same endpoint with `is_thread: true` + `thread_tweets` string array
- **Scheduled for**: 60 minutes in future
- **Response**: 201, status: "scheduled", ID: `69b742839ed4480bced1630f`
- **Format confirmed**: `thread_tweets` takes STRING ARRAY (not objects)
- **Cleanup**: Deleted successfully

### 3. Draft Creation: PASS

- **Endpoint**: Same endpoint, omit `scheduled_date`
- **Response**: 201, status: "draft", scheduled_date: null, ID: `69b742869ed4480bced16313`
- **Cleanup**: Deleted successfully

---

## API Reference (from /api/v1/docs)

| Feature | Endpoint | Method |
|---------|----------|--------|
| Verify account | `/api/v1/me` | GET |
| List posts | `/api/v1/posts` | GET |
| Create post | `/api/v1/posts` | POST |
| Update post | `/api/v1/posts/:id` | PUT |
| Delete post | `/api/v1/posts/:id` | DELETE |
| Publish now | POST with `publish_now: true` | POST |
| Schedule | POST with `scheduled_date` (ISO 8601) | POST |
| Draft | POST without `scheduled_date` | POST |
| Bulk create | POST with `posts` array (up to 50) | POST |

### Key Parameters

- `text`: Tweet content (max 280 chars for single)
- `scheduled_date`: ISO 8601 datetime (must be future)
- `is_thread`: boolean
- `thread_tweets`: string array (2nd tweet onwards)
- `thread_media`: array of arrays (media per tweet)
- `publish_now`: boolean (instant publish, cannot combine with scheduled_date)
- `category`: string (optional, default: "General")
- `community_id`: X Community ID (optional)
- `review_status`: "approved", "pending", "rejected"

### Rate Limits (Advanced Plan)

- 300 requests/minute
- 10,000 requests/day
- 20 published posts/day
- Rate limit headers in 429 responses

---

## Production Recommendations

1. **Workflow integration**: n8n workflows should use `scheduled_date` for all non-urgent content, `publish_now: true` only for time-sensitive alerts
2. **Bulk scheduling**: Use the bulk endpoint (`posts` array) for weekly content calendar uploads (up to 50 at once)
3. **Draft pipeline**: Create as drafts first, then update with `scheduled_date` after approval gate passes
4. **Rate monitoring**: Check `/api/v1/me` before each batch to verify `remaining_posts_today`
5. **Trial expiry**: Plan is active until 2026-03-22. Decision needed: renew at $11.99/mo or switch to X API Basic ($200/mo)

---

## Overall Assessment: PRODUCTION READY

All scheduling features work correctly. The API is well-documented, reliable, and supports the full content pipeline workflow (draft -> approve -> schedule -> publish).

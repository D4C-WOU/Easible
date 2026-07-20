# EASIBLE — Citizen Public Services Platform

A full-stack citizen-services application that lets people **find nearby government/public facilities, book appointments, submit complaints, and trigger emergency (SOS) alerts** — with a dedicated **Admin Command Center** for staff to manage bookings, complaints, and emergencies.

Built as a **Flutter** mobile/web/desktop app backed by a **FastAPI** REST API and a **MySQL** database.

---

## 1. Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (Android, iOS, Web, Windows, Linux, macOS) |
| State/Nav | `go_router` for navigation, plain `StatefulWidget` + services for state |
| Backend | FastAPI (Python) |
| ORM | SQLAlchemy |
| Database | MySQL |
| Auth | JWT (`python-jose`) + bcrypt password hashing (`passlib`) |
| Location | `geolocator` (device GPS) + Haversine formula (server-side distance) |
| Maps/Calls | `url_launcher` (deep-links to Google Maps / phone dialer) |

---

## 2. Project Structure

```
Easible/
├── backend/
│   └── app/
│       ├── api/
│       │   ├── routes/        # One router per resource (auth, booking, complaint, panic, ...)
│       │   └── deps.py        # Shared dependencies: get_db, get_current_user, get_current_admin
│       ├── core/               # config.py (env vars), security.py (JWT + bcrypt)
│       ├── db/                 # SQLAlchemy engine/session setup
│       ├── models/              # SQLAlchemy ORM models (one per table)
│       ├── schemas/            # Pydantic request/response schemas
│       └── main.py             # FastAPI app instance, CORS, router registration
│
└── frontend/
    └── lib/
        ├── core/                # Theme, and shared widgets (AppScaffold, PrimaryButton, StatusChip...)
        ├── features/            # One folder per screen group (auth, home, booking, admin, panic, ...)
        ├── models/              # Dart data models (Facility, Category)
        ├── routes/              # go_router route table + auth/role guards
        └── services/            # HTTP layer — one service class per backend resource
```

---

## 3. Core Features

### Citizen-facing
- **Signup / Login** — JWT issued on success, role (`user`/`admin`) embedded in the token
- **Directory** — browse/search public-service categories (Hospital, Police, Fire, Pharmacy, Municipal, Ambulance, RTO, Electricity)
- **Facilities List** — filter facilities by category, city, and state
- **Book Appointment** — view available 30-minute service slots and *request* a booking (goes to `pending`, awaiting admin approval)
- **My Bookings** — track status of all personal bookings (pending / accepted / rejected)
- **Complaints** — file a complaint against a specific facility or as a general issue; track resolution status
- **Requirements** — look up required documents for each public service
- **Crowd Status** — live Low/Medium/High indicator based on the ratio of booked-to-total slots
- **Emergency / Panic (SOS)** — one-tap alert that shares live GPS location with the nearest support facilities; publicly accessible without login

### Admin-facing
- **Admin Command Center** — live dashboard with counts of confirmed bookings, open complaints, panic alerts, and pending requests
- **Manage Bookings** — accept/reject pending appointment requests; rejecting frees the slot back up
- **Confirmed Bookings** — read-only view of accepted appointments
- **Booking Requests** — handle the public callback-request form (no login required to submit)
- **Complaints** — resolve/reopen citizen complaints, enriched with facility + category context
- **Emergency Alerts** — view all triggered SOS alerts with user identity and GPS coordinates
- **Create Service Slot** — open new 30-minute appointment windows at any facility

---

## 4. Booking Approval Workflow

Unlike a typical instant-booking flow, Easible uses an **approval-gated booking model**:

1. Citizen taps **"Request Appointment"** on an available slot.
2. Backend creates the booking with `status = "pending"` and immediately marks the slot `available = false` (prevents double-booking while awaiting review).
3. Admin sees the request in **Manage Bookings** with full context: citizen name/email/phone, facility, category, and time window.
4. Admin **Accepts** (`status = "accepted"`) or **Rejects** (`status = "rejected"`, and the slot is freed back to `available = true`).
5. The citizen's **My Bookings** screen reflects the live status via a color-coded `StatusChip`.

---

## 5. Authentication & Authorization

- Password hashing: **bcrypt** via `passlib`.
- On login/signup, the backend issues a JWT containing `user_id` and `role`, expiring after `ACCESS_TOKEN_EXPIRE_MINUTES` (default 60).
- `get_current_user` dependency decodes and validates the JWT on every protected route.
- `get_current_admin` additionally checks `role == "admin"` and returns `403 Forbidden` otherwise.
- On the Flutter side, `AuthService.getRole()` decodes the locally stored JWT (via `jwt_decoder`) to drive route guarding — the router redirects non-admins away from any `/admin/*` path and redirects unauthenticated users to `/login`.
- Tokens are persisted with `flutter_secure_storage` (`StorageService`).

---

## 6. API Reference (Summary)

| Resource | Method | Path | Auth |
|---|---|---|---|
| Auth | POST | `/auth/signup`, `/auth/login` | Public |
| Categories | GET | `/categories/` | Public |
| Facilities | GET | `/facilities/?category_id=` | Public |
| Requirements | GET | `/requirements/` | Public |
| Slots | GET `/slots/`, POST `/slots/create`, DELETE `/slots/{id}` | Public read / Admin write |
| Bookings | POST `/bookings/create`, GET `/bookings/my`, GET `/bookings/`, PUT `/bookings/{id}` | User / Admin |
| Complaints | POST `/complaints/`, GET `/complaints/my`, GET `/complaints/`, PUT `/complaints/{id}` | User / Admin |
| Booking Requests | POST `/booking-requests/` (public), GET/PUT (admin) | Mixed |
| Crowd | GET | `/crowd/` | Public |
| Panic | GET `/panic/nearby`, POST `/panic/`, GET `/panic/` | Public / User / Admin |
| Admin | GET `/admin/dashboard`, GET `/admin/stats` | Admin |

Full FastAPI interactive docs are available at `/docs` once the backend is running (Swagger UI).

---

## 7. Getting Started

### Backend

```bash
cd backend
python -m venv venv
source venv/bin/activate   # venv\Scripts\activate on Windows
pip install -r requirements.txt
```

Create a `.env` file in `backend/`:

```
DB_USER=your_mysql_user
DB_PASSWORD=your_mysql_password
DB_HOST=localhost
DB_NAME=easible_db
SECRET_KEY=your_secret_key
```

Run the API:

```bash
uvicorn app.main:app --reload
```

Tables are auto-created on startup via `Base.metadata.create_all(bind=engine)`.

### Frontend

```bash
cd frontend
flutter pub get
flutter run
```

**Base URL configuration** (`lib/services/api_service.dart`):
- Android emulator → `http://10.0.2.2:8000`
- Web / desktop → `http://127.0.0.1:8000`

### Test Credentials

| Role | Email | Password |
|---|---|---|
| Admin | admin@example.com | admin123 |
| User | rahul.sharma@gmail.com | admin123 |
| User | priya.patel@gmail.com | admin123 |

---

## 8. Database Overview

| Table | Purpose |
|---|---|
| `users` | Citizens + one admin account; role-based access |
| `categories` | 8 public-service categories |
| `facilities` | ~120 facility records across 10 Indian states |
| `requirements` | Required documents per category/facility |
| `slots` | 30-minute appointment windows per facility |
| `booking` | Citizen appointment requests + status |
| `complaints` | Citizen-filed complaints + status |
| `booking_requests` | Public no-login callback request form |
| `panic_alerts` | SOS alert log with GPS + timestamp |

Note: `services` was renamed to `requirements` at the DB level; no legacy references remain.

---

## 9. Known Limitations / Backlog

- `requirement_screen.dart` references `processing_time`/`fees` fields not present in the DB — cosmetic placeholders only.
- `panic_screen.dart` has some hardcoded fallback text or reference-ID formatting for offline/demo cases.
- Light theme only — no dark mode yet.
- Some schemas still use the deprecated Pydantic v1 `orm_mode = True` instead of v2's `from_attributes = True` (functional, but emits warnings).
- `google_maps_flutter` is a declared dependency but the app currently uses `url_launcher` deep-links instead of an embedded map view.

---

## 10. License

Educational / academic project — no license specified.

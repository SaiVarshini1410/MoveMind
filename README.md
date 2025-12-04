# MoveMind - Full-Stack Moving Planner & Inventory Management System

MoveMind is a full-stack relocation management application that helps users organize and manage every aspect of their move - including moves, rooms, boxes, items, documents, utilities, categories, appointments, and more.

The backend uses **Node.js + Express** with **MySQL 8**.

The frontend is built using **React + MUI**.

This README provides a complete end-to-end guide to set up, configure, and run the project locally.

---

## 1. Technology Stack

### Backend
- Node.js (v18+)
- Express.js
- MySQL 8.x
- Stored Procedures, Functions, Triggers
- JWT Authentication
- bcrypt for password hashing
- dotenv for config management

### Frontend
- React
- React Router
- Axios API Client
- Material UI

---

## 2. Project Structure

```
movemind/
│
├── backend/
│   ├── controllers/
│   ├── routes/
│   ├── middleware/
│   ├── db.js
│   ├── package.json
│   ├── .env.example
│
├── frontend/
│   ├── src/
│   ├── package.json
│   ├── .env.example
│
└── db/
    └── movemind_dump.sql  # FULL SQL DUMP (tables + procedures + triggers + seed)
```

---

## 3. Prerequisites

Install the following:

- **Git**
- **Node.js v18+**
- **npm**
- **MySQL Server 8.x**

Check versions:

```bash
git --version
node -v
npm -v
mysql --version
```

---

## 4. Extracting the Project

1. Download the `movemind.zip` file from the submission
2. Extract the ZIP file to your desired location
3. Open the extracted `movemind` folder

---

## 5. Database Setup (MySQL)

### 5.1 Create the Database

1. Open **MySQL Workbench**
2. Connect to your local MySQL server
3. Click on **"Create a new schema"** (database icon) in the toolbar
4. Enter database name: `movemind_db`
5. Click **Apply** -> **Apply** -> **Finish**

### 5.2 Import and Run the SQL Dump

1. Go to **File** -> **Open SQL Script**
2. Navigate to your project folder: `db/movemind_dump.sql`
3. Click the **lightning bolt icon** to run the script
4. Wait for completion

This sets up all tables, stored procedures, triggers, functions, and seed data.

---

## 6. Backend Setup

1. Open terminal/command prompt
2. Navigate to the backend folder:

```bash
cd movemind/backend
```

3. Install dependencies:

```bash
npm install
```

### 6.1 Backend Environment File

1. In the `backend` folder, create a new file named `.env`
2. Open the `.env` file in any text editor
3. Add the following configuration:

```ini
PORT=5001
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=movemind_db
JWT_SECRET=your_hash
JWT_EXPIRES=1h
```

4. Replace `your_password` with your actual MySQL password
5. Replace `your_hash` with any secure random string
6. Save the file

**Important:** The default backend port is `5001`. If you change this port, you must also update the frontend API configuration.

### 6.2 Run the Backend

```bash
npm run dev
```

or

```bash
npm start
```

Expected output:

```
Server running on port 5001
Connected to MySQL
```

---

## 7. Frontend Setup

1. Open a **new** terminal/command prompt window
2. Navigate to the frontend folder:

```bash
cd movemind/frontend
```

3. Install dependencies:

```bash
npm install
```

### 7.1 Frontend API Configuration

The frontend is configured to connect to the backend at `http://localhost:5001/api`.

**If you changed the backend PORT in the `.env` file**, you must update the frontend configuration:

1. Open `frontend/src/api/apiClient.js`
2. Find this line:

```javascript
baseURL: "http://localhost:5001/api"
```

3. Change `5001` to match your backend PORT
4. Save the file

### 7.2 Start the Frontend

In the frontend terminal, run:

```bash
npm start
```

The application will open automatically in your browser at:

```
http://localhost:3000
```

---

## 8. Application Overview (What You Can Do)

After backend + frontend are running:

### User Authentication
- Register
- Login
- JWT-based protected routes
- View profile

### Moves
- Create/update/delete moves
- Each move belongs to a user

### Rooms
- Add rooms inside a move
- Used for box organization

### Boxes
- Create boxes inside rooms
- Each box has a label, QR code, and metadata

### Items
- Add items into boxes

### Categories
- Global list of categories
- Attach/detach categories to boxes

### Documents
- Upload document entries for a move
- Example: Lease, receipts, inventory sheets

### Utilities
- Attach utilities (electricity, gas, water, internet)
- Track start/stop dates and status

### Appointments
- Set appointments related to a move

### Data Integrity
- Everything is enforced via stored procedures + triggers
- No raw SQL logic inside backend controllers

---

## 9. Quick Setup Checklist

### Backend
- ☑ Run `npm install`
- ☑ Create `.env`
- ☑ Start server (`npm run dev`)

### Frontend
- ☑ Run `npm install`
- ☑ Create `.env`
- ☑ Start UI (`npm run dev`)

### Database
- ☑ MySQL installed
- ☑ `movemind_db` created
- ☑ SQL dump imported successfully

---

**Happy Moving with MoveMind! 📦✨**
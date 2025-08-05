#  💼 JobSkill – JSP Job Portal Project

JobSkill is a job portal web application developed using Java (JSP), HTML, CSS, JavaScript, Bootstrap, and MySQL.

This document provides step-by-step instructions to run the project both:
- ✅ With Eclipse (for developers)
- ✅ Without Eclipse (for end users or deployment)

---

## 📁 Project Structure

```

JobSkill/
├── src/
├── WebContent/
│   ├── index.jsp
│   ├── login.jsp
│   ├── ...
│   └── WEB-INF/
│       └── web.xml
├── jobskill.zip
├── README.md

````

---

## ⚙️ Requirements

| Software        | Version / Notes                        |
|-----------------|----------------------------------------|
| Java JDK        | 8 or higher                            |
| Apache Tomcat   | 8.5 / 10.0                              |
| MySQL Server    | 5.7 or higher                          |
| MySQL Workbench | Optional, for database GUI             |
| Eclipse IDE     | Optional, for developer use            |
| Web Browser     | Chrome / Firefox recommended           |

---

## 🚀 How to Run with Eclipse (for Developers)

### 1️⃣ Import Project into Eclipse

1. Open Eclipse (EE version)
2. Go to: `File → Import → Existing Projects into Workspace`
3. Browse and select the `JobSkill` folder
4. Click Finish

---

### 2️⃣ Configure Apache Tomcat in Eclipse

1. Go to: `Servers` tab → Right Click → `New → Server`
2. Select `Apache → Tomcat v9.0` → Browse to your Tomcat folder
3. Add `JobSkill` project to the server

---

### 3️⃣ Set Up MySQL Database

1. Open MySQL Workbench
2. Go to: `Server → Data Import`
3. Select: `Import from Self-Contained File`
4. File: Select `jobskill.zip extract`
5. Default Target Schema: `jobskill`
6. ✅ Check: "Create Schema if it does not exist"
7. Click `Start Import`

---

### 4️⃣ Configure DB Connection in Code

In your JSP config file (`dbconfig.jsp` or similar):

```jsp
<%
    String url = "jdbc:mysql://localhost:3306/jobskill";
    String user = "root";
    String password = "root";
%>
````

---

### 5️⃣ Run the Project

* Start server from Eclipse (`Right-click → Start`)
* Visit: `http://localhost:8080/JobSkill/`

---

## 🌐 How to Run Without Eclipse (for Non-Technical Users)

> Use this if you want to run the project directly with Tomcat and MySQL.

---

### 🔁 Step 1: Install Required Software

* [Java JDK](https://www.oracle.com/java/technologies/javase-downloads.html)
* [Apache Tomcat 9.0](https://tomcat.apache.org/download-90.cgi)
* [MySQL Server](https://dev.mysql.com/downloads/)
* [MySQL Workbench (Optional)](https://dev.mysql.com/downloads/workbench/)

---

### 📂 Step 2: Set Up the Database

1. Open MySQL Workbench
2. Go to: `Server → Data Import`
3. Select: `Import from Self-Contained File`
4. File: Choose `jobskill.zip and extract`
5. Schema Name: `jobskill`
6. ✅ Check: “Create Schema if it does not exist”
7. Click `Start Import`

---

### 📦 Step 3: Deploy WAR File

1. Copy the file `JobSkill.war` (you can export this from Eclipse)
2. Paste it into:
   `C:\apache-tomcat-9.0.xx\webapps\`

---

### ▶️ Step 4: Start Tomcat Server

1. Open: `C:\apache-tomcat-9.0.xx\bin\`
2. Double-click: `startup.bat`

---

### 🌐 Step 5: Access Project in Browser

Go to your browser and open:

```
http://localhost:8080/JobSkill/
```

---

## 👤 Default Admin Credentials

| Role  | Email                                           | Password |
| ----- | ----------------------------------------------- | -------- |
| Admin | [abuhurera@gmail.com]                            |  1234   |
| User  | [abdulrehman@gmail.com]                          |  1234   |

> You can modify these in the MySQL `users` table.

---

## 💡 Tips

* Make a desktop shortcut for `startup.bat`
* Bookmark the portal URL in browser
* Check MySQL service is running if error occurs

---

## 📞 Support

For support or documentation issues, please contact:

**Developer**: Abu Hurera
**Email**: [junejoabuhurera52@gmail.com](junejoabuhurera52@gmail.com)

---

## 🧾 License

This project is provided for educational and demo purposes only.


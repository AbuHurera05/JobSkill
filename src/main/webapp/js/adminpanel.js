// Function to Show Sections Dynamically
function showSection(section) {
    // Hide all sections
    document.getElementById("addJobSection").style.display = "none";
    document.getElementById("viewJobsSection").style.display = "none";
    document.getElementById("viewAppliedSection").style.display = "none";
    document.getElementById("addDepartmentSection").style.display = "none";
    document.getElementById("addCompanySection").style.display = "none";
    document.getElementById("showCompanySection").style.display = "none";

    // Debugging statement
    console.log("Showing section: " + section);

    // Show the selected section
    if (section === "addJob") {
        document.getElementById("addJobSection").style.display = "block";
    } else if (section === "viewJobs") {
        document.getElementById("viewJobsSection").style.display = "block";
    } else if (section === "viewApplied") {
        document.getElementById("viewAppliedSection").style.display = "block";
    } else if (section === "addDepartment") {
        document.getElementById("addDepartmentSection").style.display = "block";
    }else if (section === "addCompany") {
        document.getElementById("addCompanySection").style.display = "block";
    }else if (section === "showCompany") {
        document.getElementById("showCompanySection").style.display = "block";
    }
}



// Form Validation
function validateForm() {
    let isValid = true;

    // Get form values
    let title = document.getElementById("title").value.trim();
    let description = document.getElementById("description").value.trim();
    let salary = document.getElementById("salary").value.trim();
    let location = document.getElementById("location").value.trim();
    let type = document.getElementById("type").value;
    let company = document.getElementById("company").value.trim();
    let jobType = document.getElementById("jobType").value;
	let jobImage = document.getElementById("jobImage").files[0];
	    

    // Error Elements
    let titleError = document.getElementById("titleError");
    let descError = document.getElementById("descError");
    let salaryError = document.getElementById("salaryError");
    let locationError = document.getElementById("locationError");
    let typeError = document.getElementById("typeError");
    let companyError = document.getElementById("companyError");
    let jobTypeError = document.getElementById("jobTypeError");
	let imageError = document.getElementById("imageError");

    // Reset previous errors
    titleError.innerText = "";
    descError.innerText = "";
    salaryError.innerText = "";
    locationError.innerText = "";
    typeError.innerText = "";
    companyError.innerText = "";
    jobTypeError.innerText = "";
	imageError.innerText = "";

    // Title Validation
    if (title === "") {
        titleError.innerText = "Job title is required.";
        isValid = false;
    }

    // Description Validation
    if (description === "") {
        descError.innerText = "Description is required.";
        isValid = false;
    } else if (description.length < 10) {
        descError.innerText = "Description must be at least 10 characters.";
        isValid = false;
    }

    // Salary Validation
    if (salary === "") {
        salaryError.innerText = "Salary is required.";
        isValid = false;
    } else if (parseInt(salary) < 10000) {
        salaryError.innerText = "Salary must be at least 10,000.";
        isValid = false;
    }

    // Location Validation
    if (location === "") {
        locationError.innerText = "Job location is required.";
        isValid = false;
    }

    // Job Type (Full/Part Time) Validation
    if (type === "") {
        typeError.innerText = "Please select job type (Full/Part Time).";
        isValid = false;
    }

    // Company Name Validation
    if (company === "") {
        companyError.innerText = "Company name is required.";
        isValid = false;
    }

    // Job Type (Permanent, Contract, etc.) Validation
    if (jobType === "") {
        jobTypeError.innerText = "Please select job type (Permanent, Contract, etc.).";
        isValid = false;
    }
	
	if (!jobImage) {
	     imageError.innerText = "Please upload a job image.";
	     isValid = false;
	 } else if (!jobImage.type.startsWith("image/")) {
	     imageError.innerText = "Only image files are allowed.";
	     isValid = false;
	 } else if (jobImage.size > 2 * 1024 * 1024) {
	     imageError.innerText = "Image size must be less than 2MB.";
	     isValid = false;
	 }

    return isValid;
}

// Sample data: Swedish verb to English verb forms mapping
const verbData = [
    { swedish: "gå", base: "go", past: "went", perfect: "gone" },
    { swedish: "äta", base: "eat", past: "ate", perfect: "eaten" },
    { swedish: "se", base: "see", past: "saw", perfect: "seen" },
    { swedish: "ta", base: "take", past: "took", perfect: "taken" },
    { swedish: "skriva", base: "write", past: "wrote", perfect: "written" },
    { swedish: "ha sönder", base: "break", past: "broke", perfect: "broken" },
    { swedish: "dricka", base: "drink", past: "drank", perfect: "drunk" },
    { swedish: "sjunga", base: "sing", past: "sang", perfect: "sung" },
    { swedish: "simma", base: "swim", past: "swam", perfect: "swum" },
    { swedish: "börja", base: "begin", past: "began", perfect: "begun" }
];

let currentVerb;
let currentForm;

// Function to generate a random question
function generateQuestion() {
    // Pick a random verb
    currentVerb = verbData[Math.floor(Math.random() * verbData.length)];

    // Pick a random form (base, past, or perfect)
    const forms = ["base", "past", "perfect"];
    currentForm = forms[Math.floor(Math.random() * forms.length)];

    // Display the question
    const questionDiv = document.getElementById("question");
    questionDiv.innerHTML = `Swedish Verb: <strong>${currentVerb.swedish}</strong><br>Form: <strong>${currentForm}</strong>`;

    // Clear the answer input and result
    document.getElementById("answerInput").value = "";
    document.getElementById("result").innerHTML = "";

    // Hide the "Next Verb" button
    document.getElementById("nextButton").style.display = "none";
}

// Function to check the user's answer
async function checkAnswer() {
    const userAnswer = document.getElementById("answerInput").value.trim().toLowerCase();
    const resultDiv = document.getElementById("result");

    // Send the user's answer and correct form to the Flask app
    const response = await fetch("http://127.0.0.1:5000/predict", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({ word: userAnswer, correctForm: currentVerb[currentForm] }),
    });

    // Parse the JSON response
    const result = await response.json();

    // Display the result
    if (result.prediction === "Valid") {
        resultDiv.innerHTML = "Correct! 🎉";
        resultDiv.style.color = "green";
    } else {
        resultDiv.innerHTML = `Incorrect. The correct answer is <strong>${currentVerb[currentForm]}</strong>.`;
        resultDiv.style.color = "red";
    }

    // Show the "Next Verb" button
    document.getElementById("nextButton").style.display = "block";
}

// Event listener for the submit button
document.getElementById("submitButton").addEventListener("click", checkAnswer);

// Event listener for the next button
document.getElementById("nextButton").addEventListener("click", () => {
    // Generate a new question
    generateQuestion();
});

// Generate the first question when the page loads
generateQuestion();
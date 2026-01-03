import React from "react"

export default function App() {
  return React.createElement(
    "div",
    { style: { textAlign: "center", padding: "50px" } },
    React.createElement("h1", null, "🚀 CI/CD Completamente Funcional"),
    React.createElement("p", null, "Frontend: Netlify ✅"),
    React.createElement("p", null, "Backend Functions: Supabase ✅"),
    React.createElement("p", null, "Infrastructure as Code: Terraform ✅")
  )
}

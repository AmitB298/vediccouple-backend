export async function fetchPanchangForUser(user) {
  return {
    date: new Date().toISOString().split("T")[0],
    location: user.pob || "Unknown",
    sunrise: "06:12",
    sunset: "18:58",
    tithi: "Shukla Tritiya",
    nakshatra: user.moonNakshatra || "Rohini",
    yoga: "Siddha",
    karana: "Taitila",
    weekday: new Date().toLocaleString("en-IN", { weekday: "long" }),
    moon_rashi: user.moonRashi || "Vrishabha",
    muhurta: {
      rahukalam: "10:30-12:00",
      abhijit: "11:42-12:30"
    },
    recommendations: {
      favorable: ["Creative work", "Gentle communication"],
      avoid: ["Legal decisions", "Major financial changes"],
      mantra: "Om Shreem Lakshmiyei Namaha",
      remedy: "Offer white flowers to the Moon"
    }
  };
}

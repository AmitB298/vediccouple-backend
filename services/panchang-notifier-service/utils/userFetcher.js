export async function fetchEligibleUsers() {
  return [
    {
      _id: "user123",
      name: "Ananya",
      dob: "1995-05-12",
      tob: "06:45",
      pob: "Jaipur",
      timezone: "Asia/Kolkata",
      moonNakshatra: "Rohini",
      moonRashi: "Vrishabha",
      currentDasha: "Venus",
      notificationsEnabled: true,
      fcmToken: "mock-fcm-token",
      webPushToken: "mock-web-token"
    }
  ];
}

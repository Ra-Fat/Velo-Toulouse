const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function seedDatabase() {
  const USER_ID = "1";

  console.log("Starting full Firestore seed with flat structure...");

  const batch = db.batch();

  // 1. User
  batch.set(db.collection("users").doc(USER_ID), {
    display_name: "Raksa",
    created_at: admin.firestore.FieldValue.serverTimestamp(),
  });

  // 2. Subscription Catalog
  const plans = [
    {
      id: "day",
      name: "Day Pass",
      price_euros: 2,
      duration_kind: "day",
    },
    {
      id: "monthly",
      name: "Monthly Pass",
      price_euros: 29.9,
      duration_kind: "month",
    },
    {
      id: "annual",
      name: "Annual Pass",
      price_euros: 150,
      duration_kind: "year",
    },
  ];

  plans.forEach((plan, index) => {
    batch.set(db.collection("subscriptions").doc(plan.id), {
      ...plan,
      is_active: true,
      sort_order: index,
    });
  });

  // 3. User Active Subscription
  const expiresAt = new Date();
  expiresAt.setMonth(expiresAt.getMonth() + 1);

  const userSubRef = db.collection("user_subscriptions").doc();
  batch.set(userSubRef, {
    user_id: USER_ID,
    subscription_id: "monthly",
    starts_at: admin.firestore.FieldValue.serverTimestamp(),
    expires_at: admin.firestore.Timestamp.fromDate(expiresAt),
    is_active: true,
    created_at: admin.firestore.FieldValue.serverTimestamp(),
  });

  // 4. Stations
  const stations = [
    { id: "1", name: "Capitole Main" },
    { id: "2", name: "Jean Jaurès" },
  ];

  stations.forEach((s) => {
    batch.set(db.collection("stations").doc(s.id), {
      name: s.name,
      is_active: true,
    });
  });

  // 5. Slots (Flat collection linked by station_id)
  const slots = [
    {
      id: "1",
      station_id: "1",
      label: "No. 01",
      bike_id: "1",
      status: "occupied",
    },
    {
      id: "2",
      station_id: "1",
      label: "No. 02",
      bike_id: "2",
      status: "occupied",
    },
    {
      id: "3",
      station_id: "1",
      label: "No. 03",
      bike_id: null,
      status: "empty",
    },
    {
      id: "4",
      station_id: "2",
      label: "No. 01",
      bike_id: "3",
      status: "occupied",
    },
    {
      id: "5",
      station_id: "2",
      label: "No. 02",
      bike_id: null,
      status: "empty",
    },
  ];

  slots.forEach((slot) => {
    batch.set(db.collection("slots").doc(slot.id), {
      station_id: slot.station_id,
      label: slot.label,
      bike_id: slot.bike_id,
      status: slot.status,
    });
  });

  // 6. Bikes
  const bikes = [
    { id: "1", number: "1001", status: "reserved", station: "1", slot: "1" },
    { id: "2", number: "1002", status: "available", station: "1", slot: "2" },
    { id: "3", number: "1003", status: "available", station: "2", slot: "4" },
  ];

  bikes.forEach((bike) => {
    batch.set(db.collection("bikes").doc(bike.id), {
      number: bike.number,
      status: bike.status,
      current_station_id: bike.station,
      current_slot_id: bike.slot,
    });
  });

  // 7. Active Booking for User 1
  const resExpires = new Date();
  resExpires.setMinutes(resExpires.getMinutes() + 15);

  const bookingRef = db.collection("bookings").doc();
  batch.set(bookingRef, {
    user_id: USER_ID,
    bike_id: "1",
    station_id: "1",
    slot_id: "1",
    reserved_at: admin.firestore.FieldValue.serverTimestamp(),
  });

  await batch.commit();
  console.log("Database seeded successfully with all entities.");
}

seedDatabase().catch(console.error);

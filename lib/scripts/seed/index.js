const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function deleteCollectionDocs(collectionName) {
  const snapshot = await db.collection(collectionName).get();
  if (snapshot.empty) return;

  const batch = db.batch();
  for (const doc of snapshot.docs) {
    batch.delete(doc.ref);
  }
  await batch.commit();
}

async function seedDatabase() {
  const USER_ID = "1";

  console.log("Starting Firestore seed aligned with mock repositories...");

  // Reset runtime collections so reseeding stays deterministic.
  await deleteCollectionDocs("bookings");
  await deleteCollectionDocs("user_subscriptions");

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
      duration_kind: "monthly",
    },
    {
      id: "annual",
      name: "Annual Pass",
      price_euros: 150,
      duration_kind: "annual",
    },
  ];

  plans.forEach((plan, index) => {
    batch.set(db.collection("subscriptions").doc(plan.id), {
      ...plan,
      is_active: true,
      sort_order: index,
    });
  });

  // 3. Stations
  const stations = [
    {
      id: "1",
      name: "Stueng Meanchey Tmei",
      latitude: 11.5306,
      longitude: 104.8783,
      code: "12",
      available_bikes_count: 2,
    },
    {
      id: "2",
      name: "Kmall",
      latitude: 11.5289,
      longitude: 104.8794,
      code: "18",
      available_bikes_count: 1,
    },
    {
      id: "3",
      name: "Prey Sor",
      latitude: 11.5278,
      longitude: 104.8822,
      code: "07",
      available_bikes_count: 1,
    },
    {
      id: "4",
      name: "Beltei International School",
      latitude: 11.5334,
      longitude: 104.8776,
      code: "24",
      available_bikes_count: 1,
    },
    {
      id: "5",
      name: "Terk Lu Stueng Meanchey",
      latitude: 11.5321,
      longitude: 104.8801,
      code: "31",
      available_bikes_count: 1,
    },
  ];

  stations.forEach((s) => {
    batch.set(db.collection("stations").doc(s.id), {
      name: s.name,
      latitude: s.latitude,
      longitude: s.longitude,
      code: s.code,
      available_bikes_count: s.available_bikes_count,
      is_active: true,
    });
  });

  // 4. Slots (flat collection linked by station_id)
  const slots = [
    { id: "1", station_id: "1", label: "No. 01", bike_id: "1", status: "occupied" },
    { id: "2", station_id: "1", label: "No. 02", bike_id: "2", status: "occupied" },
    { id: "10", station_id: "1", label: "No. 10", bike_id: "10", status: "occupied" },
    { id: "4", station_id: "2", label: "No. 04", bike_id: "3", status: "occupied" },
    { id: "11", station_id: "3", label: "No. 11", bike_id: "11", status: "occupied" },
    { id: "12", station_id: "4", label: "No. 12", bike_id: "12", status: "occupied" },
    { id: "13", station_id: "5", label: "No. 13", bike_id: "13", status: "occupied" },
  ];

  slots.forEach((slot) => {
    batch.set(db.collection("slots").doc(slot.id), {
      station_id: slot.station_id,
      label: slot.label,
      bike_id: slot.bike_id,
      status: slot.status,
    });
  });

  // 5. Bikes
  const bikes = [
    { id: "1", number: "1001", status: "reserved", station: "1", slot: "1" },
    { id: "2", number: "1002", status: "available", station: "1", slot: "2" },
    { id: "3", number: "1003", status: "available", station: "2", slot: "4" },
    { id: "10", number: "4872", status: "available", station: "1", slot: "10" },
    { id: "11", number: "5021", status: "available", station: "3", slot: "11" },
    { id: "12", number: "5022", status: "available", station: "4", slot: "12" },
    { id: "13", number: "5023", status: "available", station: "5", slot: "13" },
  ];

  bikes.forEach((bike) => {
    batch.set(db.collection("bikes").doc(bike.id), {
      number: bike.number,
      status: bike.status,
      current_station_id: bike.station,
      current_slot_id: bike.slot,
    });
  });

  // 6. Keep runtime state empty by default, like mock repositories:
  // - no active booking rows
  // - no active user_subscriptions rows

  await batch.commit();
  console.log("Database seeded successfully (mock-aligned).");
}

seedDatabase().catch(console.error);

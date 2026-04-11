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

  batch.set(db.collection("users").doc(USER_ID), {
    display_name: "Raksa",
    created_at: admin.firestore.FieldValue.serverTimestamp(),
  });

  const plans = [
    { id: "day",     name: "Day Pass",     price_euros: 2,    duration_kind: "day"     },
    { id: "monthly", name: "Monthly Pass", price_euros: 29.9, duration_kind: "monthly" },
    { id: "annual",  name: "Annual Pass",  price_euros: 150,  duration_kind: "annual"  },
  ];

  plans.forEach((plan, index) => {
    batch.set(db.collection("subscriptions").doc(plan.id), {
      ...plan,
      is_active: true,
      sort_order: index,
    });
  });


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

  const slots = [];
  for (let stationIndex = 1; stationIndex <= 5; stationIndex++) {
    for (let slotIndex = 1; slotIndex <= 5; slotIndex++) {
      const slotId = `${stationIndex}0${slotIndex}`;
      const bikeId = `${stationIndex}0${slotIndex}`;
      slots.push({
        id: slotId,
        station_id: String(stationIndex),
        label: `No. ${String(slotIndex).padStart(2, "0")}`,
        bike_id: bikeId,
        status: "occupied",
      });
    }
  }

  slots.forEach((slot) => {
    batch.set(db.collection("slots").doc(slot.id), {
      station_id: slot.station_id,
      label: slot.label,
      bike_id: slot.bike_id,
      status: slot.status,
    });
  });

  const bikes = [];
  for (let stationIndex = 1; stationIndex <= 5; stationIndex++) {
    for (let bikeIndex = 1; bikeIndex <= 5; bikeIndex++) {
      const bikeId = `${stationIndex}0${bikeIndex}`;
      const slotId = `${stationIndex}0${bikeIndex}`;
      const bikeNumber = String(stationIndex * 1000 + bikeIndex);
      const isFirstBike = bikeIndex === 1;
      bikes.push({
        id: bikeId,
        number: bikeNumber,
        status: isFirstBike ? "reserved" : "available",
        current_station_id: String(stationIndex),
        current_slot_id: slotId,
      });
    }
  }

  bikes.forEach((bike) => {
    batch.set(db.collection("bikes").doc(bike.id), {
      number: bike.number,
      status: bike.status,
      current_station_id: bike.current_station_id,
      current_slot_id: bike.current_slot_id,
    });
  });


  await batch.commit();
  console.log("✅ Database seeded successfully (5 stations × 5 bikes).");
  console.log("   Stations:");
  stations.forEach((s) =>
    console.log(`   [${s.code}] ${s.name}  (${s.latitude}, ${s.longitude})`)
  );
}

seedDatabase().catch(console.error);
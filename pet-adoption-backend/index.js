const express = require("express");
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware to parse JSON
app.use(express.json());

// GET endpoint that returns pet adoption data
app.get("/api/pets", (req, res) => {
  const data = {
    pets: [
      {
        id: "1",
        name: "Buddy",
        type: "Dog",
        description:
          "Buddy is a friendly and energetic Golden Retriever who loves playing fetch and going on long walks. He's great with kids and other dogs, making him the perfect family companion.",
        breed: "Golden Retriever",
        age: "3",
        gender: "Male",
        price: 250.0,
        isAdopted: false,
        imageUrls: [
          "https://images.unsplash.com/photo-1552053831-71594a27632d?w=400&h=300&fit=crop",
          "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400&h=300&fit=crop",
        ],
      },
      {
        id: "2",
        name: "Luna",
        type: "Cat",
        description:
          "Luna is a beautiful and calm Persian cat who enjoys quiet moments and gentle pets. She's perfect for someone looking for a peaceful and loving companion.",
        breed: "Persian",
        age: "2",
        gender: "Female",
        price: 180.0,
        isAdopted: true,
        imageUrls: [
          "https://images.unsplash.com/photo-1574158622682-e40e69881006?w=400&h=300&fit=crop",
          "https://images.unsplash.com/photo-1596854407944-bf87f6fdd49e?w=400&h=300&fit=crop",
        ],
      },
      {
        id: "3",
        name: "Max",
        type: "Dog",
        description:
          "Max is a loyal German Shepherd with excellent training. He's protective, intelligent, and would make an excellent guard dog while being gentle with family.",
        breed: "German Shepherd",
        age: "4",
        gender: "Male",
        price: 300.0,
        isAdopted: false,
        imageUrls: [
          "https://images.unsplash.com/photo-1551717743-49959800b1f6?w=400&h=300&fit=crop",
          "https://images.unsplash.com/photo-1589941013453-ec89f33b5e95?w=400&h=300&fit=crop",
        ],
      },
      {
        id: "4",
        name: "Whiskers",
        type: "Cat",
        description:
          "Whiskers is a playful tabby cat who loves climbing and exploring. He's very social and gets along well with other cats and even dogs.",
        breed: "Tabby",
        age: "1",
        gender: "Male",
        price: 120.0,
        isAdopted: false,
        imageUrls: [
          "https://images.unsplash.com/photo-1574144611937-0df059b5ef3e?w=400&h=300&fit=crop",
          "https://images.unsplash.com/photo-1592194996308-7b43878e84a6?w=400&h=300&fit=crop",
        ],
      },
      {
        id: "5",
        name: "Bella",
        type: "Dog",
        description:
          "Bella is a sweet and gentle Labrador who loves swimming and retrieving. She's been trained and is perfect for active families who enjoy outdoor activities.",
        breed: "Labrador",
        age: "2",
        gender: "Female",
        price: 220.0,
        isAdopted: false,
        imageUrls: [
          "https://images.unsplash.com/photo-1518717758536-85ae29035b6d?w=400&h=300&fit=crop",
          "https://images.unsplash.com/photo-1552053831-71594a27632d?w=400&h=300&fit=crop",
        ],
      },
      {
        id: "6",
        name: "Shadow",
        type: "Cat",
        description:
          "Shadow is a mysterious black cat with striking yellow eyes. He's independent but affectionate and would suit someone who appreciates a cat with personality.",
        breed: "Bombay",
        age: "3",
        gender: "Male",
        price: 160.0,
        isAdopted: true,
        imageUrls: [
          "https://images.unsplash.com/photo-1561948955-570b270e7c36?w=400&h=300&fit=crop",
          "https://images.unsplash.com/photo-1573865526739-10659fec78a5?w=400&h=300&fit=crop",
        ],
      },
      {
        id: "7",
        name: "Charlie",
        type: "Dog",
        description:
          "Charlie is an adorable Beagle puppy with boundless energy. He's curious, friendly, and loves meeting new people. Perfect for families with children.",
        breed: "Beagle",
        age: "6 months",
        gender: "Male",
        price: 280.0,
        isAdopted: false,
        imageUrls: [
          "https://images.unsplash.com/photo-1544717297-fa95b6ee9643?w=400&h=300&fit=crop",
          "https://images.unsplash.com/photo-1518717758536-85ae29035b6d?w=400&h=300&fit=crop",
        ],
      },
      {
        id: "8",
        name: "Mittens",
        type: "Cat",
        description:
          "Mittens is a fluffy Maine Coon with distinctive white paws. She's gentle, loves being brushed, and would be perfect for someone who enjoys grooming and caring for long-haired cats.",
        breed: "Maine Coon",
        age: "4",
        gender: "Female",
        price: 200.0,
        isAdopted: false,
        imageUrls: [
          "https://images.unsplash.com/photo-1574158622682-e40e69881006?w=400&h=300&fit=crop",
          "https://images.unsplash.com/photo-1596854407944-bf87f6fdd49e?w=400&h=300&fit=crop",
        ],
      },
      {
        id: "9",
        name: "Rocky",
        type: "Dog",
        description:
          "Rocky is a strong and loyal Rottweiler with a gentle heart. Despite his intimidating appearance, he's incredibly sweet and loves belly rubs.",
        breed: "Rottweiler",
        age: "5",
        gender: "Male",
        price: 350.0,
        isAdopted: false,
        imageUrls: [
          "https://images.unsplash.com/photo-1605568427561-40dd23c2acea?w=400&h=300&fit=crop",
          "https://images.unsplash.com/photo-1551717743-49959800b1f6?w=400&h=300&fit=crop",
        ],
      },
      {
        id: "10",
        name: "Princess",
        type: "Cat",
        description:
          "Princess is a regal Siamese cat with beautiful blue eyes. She's vocal, intelligent, and forms strong bonds with her humans. She prefers being the only pet.",
        breed: "Siamese",
        age: "3",
        gender: "Female",
        price: 190.0,
        isAdopted: false,
        imageUrls: [
          "https://images.unsplash.com/photo-1573865526739-10659fec78a5?w=400&h=300&fit=crop",
          "https://images.unsplash.com/photo-1574158622682-e40e69881006?w=400&h=300&fit=crop",
        ],
      },
      {
        id: "11",
        name: "Cooper",
        type: "Dog",
        description:
          "Cooper is a playful Border Collie who's extremely intelligent and energetic. He needs an active family and would excel at agility training or dog sports.",
        breed: "Border Collie",
        age: "2",
        gender: "Male",
        price: 270.0,
        isAdopted: false,
        imageUrls: [
          "https://images.unsplash.com/photo-1551717743-49959800b1f6?w=400&h=300&fit=crop",
          "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400&h=300&fit=crop",
        ],
      },
      {
        id: "12",
        name: "Smokey",
        type: "Cat",
        description:
          "Smokey is a laid-back Russian Blue with a beautiful silver coat. He's quiet, observant, and perfect for someone who wants a calm and low-maintenance companion.",
        breed: "Russian Blue",
        age: "5",
        gender: "Male",
        price: 170.0,
        isAdopted: true,
        imageUrls: [
          "https://images.unsplash.com/photo-1596854407944-bf87f6fdd49e?w=400&h=300&fit=crop",
          "https://images.unsplash.com/photo-1561948955-570b270e7c36?w=400&h=300&fit=crop",
        ],
      },
      {
        id: "13",
        name: "Daisy",
        type: "Dog",
        description:
          "Daisy is a cheerful Cocker Spaniel with a beautiful golden coat. She's gentle, loves children, and has a calm temperament that makes her perfect for families.",
        breed: "Cocker Spaniel",
        age: "3",
        gender: "Female",
        price: 240.0,
        isAdopted: false,
        imageUrls: [
          "https://images.unsplash.com/photo-1552053831-71594a27632d?w=400&h=300&fit=crop",
          "https://images.unsplash.com/photo-1518717758536-85ae29035b6d?w=400&h=300&fit=crop",
        ],
      },
      {
        id: "14",
        name: "Oliver",
        type: "Cat",
        description:
          "Oliver is a charming orange tabby with a big personality. He's social, loves attention, and would be perfect for someone who wants an interactive and engaging pet.",
        breed: "Orange Tabby",
        age: "2",
        gender: "Male",
        price: 140.0,
        isAdopted: false,
        imageUrls: [
          "https://images.unsplash.com/photo-1574144611937-0df059b5ef3e?w=400&h=300&fit=crop",
          "https://images.unsplash.com/photo-1592194996308-7b43878e84a6?w=400&h=300&fit=crop",
        ],
      },
    ],
  };

  res.json(data);
});

// Root endpoint
app.get("/", (req, res) => {
  res.json({
    message: "Welcome to the Pet Adoption API!",
    endpoints: {
      pets: "/api/pets",
      data: "/api/data",
    },
  });
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Visit http://localhost:${PORT} to see the API`);
  console.log(
    `Visit http://localhost:${PORT}/api/pets to get the pet adoption data`
  );
});

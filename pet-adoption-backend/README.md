# Pet Adoption Backend

A simple Express.js API server for the pet adoption application that provides pet data for adoption.

## Setup

1. Install dependencies:

   ```bash
   npm install
   ```

2. Start the server:

   ```bash
   npm start
   ```

   Or for development:

   ```bash
   npm run dev
   ```

## API Endpoints

### GET `/`

Returns a welcome message and available endpoints.

### GET `/api/pets`

Returns a comprehensive list of pets available for adoption, including:

- Pet details (name, type, breed, age, gender)
- Descriptions and characteristics
- Adoption status and pricing
- Image URLs for each pet

### GET `/api/data`

Returns JSON data. You can modify the response in `index.js` to return your desired JSON structure.

## Testing the API

Once the server is running, you can test the endpoints:

- Visit `http://localhost:3000` in your browser
- Visit `http://localhost:3000/api/pets` to see the pet adoption data
- Visit `http://localhost:3000/api/data` to see the JSON response

## Pet Data Structure

Each pet in the API response includes:

- `id`: Unique identifier
- `name`: Pet's name
- `type`: Animal type (Dog/Cat)
- `description`: Detailed description of the pet
- `breed`: Specific breed
- `age`: Pet's age
- `gender`: Male/Female
- `price`: Adoption fee
- `isAdopted`: Adoption status
- `imageUrls`: Array of image URLs

## Customizing the JSON Response

To modify the pet data returned by the `/api/pets` endpoint, edit the `data` object in the `index.js` file around line 10-20.

# Corezap Project Documentation

## 1. Project Overview
**Corezap** is a ride-sharing/logistics platform built with **Node.js, Express.js**, and **MongoDB**. It facilitates interactions between Users (Riders), Drivers, and Fleet Owners, managed by an Admin panel. Real-time features such as ride tracking and driver availability are powered by **Socket.io**.

---

## 2. Key Entities (Models)
The system revolves around several core data models:

*   **User**: End-customers who book rides.
*   **Driver**: Service providers with verified profiles and vehicles.
*   **Order (Ride)**: Represents a trip/transaction, tracking status from creation to completion.
*   **Vehicle**: Associates with drivers; requires verification.
*   **Wallet/Transaction**: Manages earnings, commissions, and payment history.
*   **Admin**: Platform administrators with oversight capabilities.
*   **Fleet**: Owners managing multiple drivers and vehicles.

---

## 3. API Flows & Endpoints

### 3.1 Authentication & User Management
**Base URL**: `/api/v1`

| Method | Endpoint | Description | Auth |
| :--- | :--- | :--- | :--- |
| `GET` | `/isUserExist` | Check if a user exists. | Public |
| `POST` | `/registerLoginUser` | Register or Login a user. | Public |
| `POST` | `/verifyOtp` | Verify OTP for login. | Public |
| `POST` | `/googleLogin` | Login via Google. | Public |
| `GET` | `/getUserById/:userId` | Get user profile. | User |
| `PUT` | `/updateUserProfile/:userId` | Update user profile (supports image upload). | User |
| `GET` | `/getAllUsers` | List all users. | Admin |

### 3.2 Driver Management
**Base URL**: `/api/v1`

| Method | Endpoint | Description | Auth |
| :--- | :--- | :--- | :--- |
| `POST` | `/driver/register` | Register a new driver (with documents: DL, Aadhaar, PAN). | Public |
| `POST` | `/driver/registerLogin` | Login/Register driver. | Public |
| `GET` | `/driver/home` | Get driver dashboard stats. | Driver |
| `PUT` | `/driver/update` | Update driver profile and documents. | Driver |
| `PATCH` | `/driver/toggleDuty/:driverId`| Toggle driver on/off duty. | Driver |
| `GET` | `/driver/earningReport` | View earnings report. | Driver |
| **Admin** | | | |
| `PATCH` | `/admin/verify/:driverId` | Verify a driver's profile. | Admin |
| `PATCH` | `/admin/driver/verifyImage/:driverId` | Verify driver's uploaded images. | Admin |
| `GET` | `/driver/getAllDriver` | List all drivers. | Admin |

### 3.3 Order (Ride) Management
**Base URL**: `/api/v1`

| Method | Endpoint | Description | Auth |
| :--- | :--- | :--- | :--- |
| `POST` | `/order/create` | Create a new ride request. | User |
| `GET` | `/order/current` | Get the currently active order. | User |
| `GET` | `/order/history` | Get user's ride history. | User |
| `GET` | `/order/driver/history` | Get driver's ride history. | Driver |
| `PATCH` | `/order/update/:orderId` | Update order (e.g., status). | User |
| `PATCH` | `/order/cancel/:orderId` | Cancel a ride. | User |
| `PATCH` | `/order/decline/:orderId` | Driver declines an order. | Driver |
| `POST` | `/order/verifyOtp` | Verify ride start OTP. | Driver/User |

### 3.4 Vehicle Management
**Base URL**: `/api/v1`

| Method | Endpoint | Description | Auth |
| :--- | :--- | :--- | :--- |
| `POST` | `/createVehicle` | Add a new vehicle. | Driver/Fleet |
| `PUT` | `/updateVehicle/:vehicleId` | Update vehicle details. | Driver |
| `PATCH` | `/admin/vehicles/verify/:vehicleId` | Verify a vehicle. | Admin |
| `GET` | `/getAllVehicles` | List all vehicles. | Admin |

### 3.5 Chat Management
**Base URL**: `/api/v1`

| Method | Endpoint | Description | Auth |
| :--- | :--- | :--- | :--- |
| `GET` | `/chat/ride/:rideId` | Get or create a chat session for a ride. | User/Driver |
| `GET` | `/chat/:chatId` | Get chat metadata. | User/Driver |
| `GET` | `/chat/:chatId/messages` | Get chat history/messages. | User/Driver |
| `POST` | `/chat/complete/:chatId` | specific status update for chat. | User/Driver |

### 3.6 Rental Packages
**Base URL**: `/api/v1`

| Method | Endpoint | Description | Auth |
| :--- | :--- | :--- | :--- |
| `GET` | `/rentalPackages` | List all rental packages. | Public |
| `GET` | `/rentalPackages/:id` | Get rental package by ID. | Public |
| `GET` | `/rental-packages/calculations` | Get rental packages with fare calculations. | Public |
| `POST` | `/rentalPackages` | Create a new rental package. | Admin |
| `PUT` | `/rentalPackages/:id` | Update a rental package. | Admin |
| `PATCH` | `/rentalPackages/status/:id` | Toggle rental package status (active/inactive). | Admin |
| `DELETE` | `/rentalPackages/:id` | Delete a rental package. | Admin |

### 3.7 Promocodes
**Base URL**: `/api/v1`

| Method | Endpoint | Description | Auth |
| :--- | :--- | :--- | :--- |
| `GET` | `/promocodes/getAll` | Get all promocodes. | Public |
| `GET` | `/promocodes/eligible` | Get eligible promocodes for user. | User |
| `GET` | `/promocodes/validateCode` | Validate a promocode. | User |
| `POST` | `/promocodes/validate` | Validate promocode with details. | User |
| `GET` | `/promocodes/:id` | Get promocode by ID. | User |
| `POST` | `/promocodes/add` | Create a new promocode. | Admin |
| `PUT` | `/promocodes/update/:id` | Update a promocode. | Admin |
| `PATCH` | `/promocodes/toggle/:id` | Toggle promocode status. | Admin |
| `DELETE` | `/promocodes/delete/:id` | Delete a promocode. | Admin |

### 3.8 Cities & Location
**Base URL**: `/api/v1`

| Method | Endpoint | Description | Auth |
| :--- | :--- | :--- | :--- |
| `GET` | `/getAllCities` | Get list of all cities. | Admin |
| `GET` | `/getCityById/:id` | Get city details by ID. | User |
| `POST` | `/createCity` | Create a new city. | User |
| `PUT` | `/updateCity/:id` | Update city information. | User |
| `DELETE` | `/deleteCity/:id` | Delete a city. | User |

> [!NOTE]
> **How users get cityId**: Users can call `GET /api/v1/getAllCities` (requires admin auth) or `GET /api/v1/getCityById/:id` to retrieve city information including the `cityId`.

### 3.9 Admin Operations
**Base URL**: `/api/v1`

| Method | Endpoint | Description | Auth |
| :--- | :--- | :--- | :--- |
| `GET` | `/admin/homeStats` | Overview statistics for dashboard. | Admin |
| `GET` | `/admin/usersStatistics` | User growth/activity stats. | Admin |
| `GET` | `/admin/revenueStatistics` | Revenue reports. | Admin |

---

## 4. Real-time Events (Socket.io)

### Connection
*   **Auth**: Token passed in `socket.handshake.auth.token`.
*   **Roles**: `Driver`, `Fleet`, `User` (Rider).

### 4.1 Driver Events
| Event Name | Direction | Description |
| :--- | :--- | :--- |
| `user:online` | Client -> Server | Driver goes online. Sends current location & vehicle info. |
| `driver:online_success` | Server -> Client | Confirmation of online status with driver data. |
| `driver:online_failed` | Server -> Client | Error if blocked/unverified. |
| `driver:location:update` | Client -> Server | Periodic location updates from driver. |
| `ride:orderCancelled` | Server -> Client | Notification if the ride they were offered is cancelled. |
| `ride:newRide` | Server -> Client | Notification of a new ride request. Payload: `{ rideId, pickup, destination, fare, ... }`. |
| `ride:reconnected` | Server -> Client | Notification on reconnection to an active ride. Payload: `{ orderId, orderStatus }`. |

### 4.2 Rider Events
| Event Name | Direction | Description |
| :--- | :--- | :--- |
| `user:online` | Client -> Server | Rider comes online. |
| `rider:location` | Client -> Server | Rider sends location to find nearby drivers. |
| `rider:nearby-drivers` | Server -> Client | Returns list of available drivers nearby. |
| `ride:request:sent` | Server -> Client | Acknowledgment that ride request was sent to drivers. Payload: `{ rideId, driversNotified }`. |
| `ride:no-drivers` | Server -> Client | Notification if no drivers are found. Payload: `{ message, searchRadius }`. |
| `ride:reconnected` | Server -> Client | Notification on reconnection to an active ride. Payload: `{ orderId, orderStatus }`. |

### 4.3 Ride Lifecycle Events
*   **Room**: `ride:{rideId}` (Drivers and Riders join this room for a specific trip).

| Event Name | Direction | Description |
| :--- | :--- | :--- |
| `ride:confirmed` | Server -> Driver | details of the ride (pickup, dropoff, fare, rider info). |
| `ride:accepted` | Server -> Client | Notification that a driver accepted. Contains driver & vehicle info + OTP. |
| `ride:status` | Server -> Client | General status updates (e.g., "Arrived", "Started", "Completed"). |
| `ride:location` | Server -> Client | Live location of the ride (driver's position). |
| `ride:location:update` | Client -> Server | Driver sends specific ride location updates. |

### 4.4 Chat Events
*   **Room**: `ride:{rideId}` (Messages are broadcasted to this room).

| Event Name | Direction | Description |
| :--- | :--- | :--- |
| `chat:sendMessage` | Client -> Server | Send a new message. Payload: `{ chatId, rideId, message, messageType }`. |
| `chat:receiveMessage` | Server -> Client | Broadcast received message to room. Payload: `{ chatId, rideId, message: SavedMessageObject }`. |
| `chat:error` | Server -> Client | Error notification if message sending fails. |
| `chat:markMessageRead` | Client -> Server | Mark a message as read. Payload: `{ chatId, lastMessageId }`. |
| `chat:messageRead` | Server -> Client | Notify other user that message was read. Payload: `{ userId, lastMessageId, readAt }`. |

---

## 5. Shared Utilities
*   **S3 Uploader**: Middleware for handling file uploads (images, documents).
*   **Auth Middleware**: JWT verification (`verifyToken`) and Role checks (`isAdmin`).

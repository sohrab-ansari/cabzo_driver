# ChatScreen GetX Architecture Diagram

## Message Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    CHATSCREEN                               │
│            (StatelessWidget + GetBuilder)                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  User Types & Clicks Send                                   │
│         ↓                                                    │
│  controller.sendMessage(rideData)                           │
│         ↓                                                    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │         CHATCONTROLLER                              │   │
│  │    (GetxController - Business Logic)                │   │
│  ├──────────────────────────────────────────────────────┤   │
│  │                                                      │   │
│  │  1. Check if already sending (isSending.value)      │   │
│  │     └─→ Return if true (prevent double send)        │   │
│  │                                                      │   │
│  │  2. Generate temp message ID                        │   │
│  │                                                      │   │
│  │  3. _addMessage()                                   │   │
│  │     ├─→ Add to messages list                        │   │
│  │     ├─→ Track ID in _sentMessageIds                 │   │
│  │     └─→ Sort by timestamp                           │   │
│  │                                                      │   │
│  │  4. Send via socket                                 │   │
│  │     └─→ socketManager.sendChatMessage()             │   │
│  │                                                      │   │
│  │  5. Wait for socket confirmation                    │   │
│  │     └─→ onChatMessageSent callback                  │   │
│  │     └─→ Reset isSending flag                        │   │
│  │                                                      │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
│  UI Listens to Rx Observables:                             │
│  ├─→ Obx(() => messages) → Shows message list             │
│  ├─→ Obx(() => isSending.value) → Button state            │
│  ├─→ Obx(() => isConnected.value) → Online status         │
│  └─→ Obx(() => isLoading.value) → Loading spinner         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Double Message Prevention

```
BEFORE (Bug):                    AFTER (Fixed):
─────────────────────────────    ──────────────────────────

User sends message               User sends message
      ↓                                ↓
Message added to UI              Message added to UI
      ↓                                ↓
Socket "sent" event              Socket "sent" event
      ↓                                ↓
_fetchChatHistory() called       NO history reload
      ↓                                ↓
API returns all messages         Message appears once ✅
      ↓
Same message in history
      ↓
Message added AGAIN ❌
      ↓
Message appears twice
```

## Rx Observable State Management

```
┌──────────────────────────────────────────────────────┐
│         CHATCONTROLLER RX STATE                      │
├──────────────────────────────────────────────────────┤
│                                                      │
│  RxList<ChatMessage> messages ←─────────┐           │
│  RxBool isLoading                       │           │
│  RxBool isLoadingHistory                │ Reactive  │
│  RxBool isConnected                     │           │
│  RxBool isSending                       │           │
│  Set<String> _sentMessageIds ←──────────┘           │
│                                                      │
└──────────────────────────────────────────────────────┘
            ↓
      GetBuilder<ChatController>
            ↓
      Obx() Widgets Rebuild
            ↓
      UI Updates Automatically
```

## Component Interaction

```
┌─────────────┐
│ ChatScreen  │ (Stateless Widget)
└──────┬──────┘
       │
       ├─→ GetBuilder<ChatController>
       │   └─→ Initializes controller
       │
       ├─→ Build UI with Obx() for reactivity
       │   ├─→ Obx(() => messages)
       │   ├─→ Obx(() => isConnected.value)
       │   ├─→ Obx(() => isSending.value)
       │   └─→ Obx(() => isLoading.value)
       │
       └─→ WillPopScope for cleanup
           └─→ Leave socket room on back


┌──────────────────────┐
│  ChatController      │ (GetxController)
├──────────────────────┤
│                      │
│  onInit()            │
│  ├─→ Initialize UI   │
│  └─→ Add listeners   │
│                      │
│  Methods:            │
│  ├─→ loadDriverInfo()│
│  ├─→ initializeChat()│
│  ├─→ sendMessage()   │
│  ├─→ _addMessage()   │
│  └─→ formatTime()    │
│                      │
│  onClose()           │
│  └─→ Cleanup         │
│                      │
└──────────────────────┘


┌────────────────────┐
│  SocketManager     │
├────────────────────┤
│                    │
│ Callbacks:         │
│ ├─→ onChatMessage │
│ ├─→ onChatJoin    │
│ ├─→ onChatError   │
│ └─→ onChatSent    │
│                    │
└────────────────────┘


┌────────────────────┐
│  API Service       │
├────────────────────┤
│                    │
│ Methods:           │
│ ├─→ fetchHistory() │
│ ├─→ sendMessage()  │
│ └─→ getAuth()      │
│                    │
└────────────────────┘
```

## Message Tracking Flow

```
START: New Message from User/Socket
│
├─→ Extract Message ID
│
├─→ Check if ID in _sentMessageIds
│
├─YES─→ Message already seen
│       └─→ SKIP (prevent duplicate)
│
└─NO──→ New Message
        │
        ├─→ Add to _sentMessageIds
        │
        ├─→ Create ChatMessage object
        │
        ├─→ Add to messages list
        │
        ├─→ Sort messages by timestamp
        │
        └─→ Trigger Obx rebuild
            └─→ UI Updates
```

## State Changes Timeline

```
Time ─────────────────────────────────────────────────────→

t=0   User clicks send
      └─→ isSending = true
          sendMessage() called

t=1   Message added to UI
      └─→ messages.add(message)
          Button shows "Sending..."

t=2   Socket sends message
      └─→ Message sent to server

t=3   Server processes

t=4   Socket returns confirmation
      └─→ onChatMessageSent triggered
          isSending = false
          Message ID saved in _sentMessageIds

t=5   (If message comes back from socket)
      └─→ Check _sentMessageIds
          Already there? SKIP
          Result: No duplicate ✅

t=6   UI stable
      └─→ Message shows once
          Send button re-enabled
```

## Memory Management

```
ALLOCATION                      DEALLOCATION
──────────                      ────────────

ChatController created          User presses back
   ├─→ TextEditingController   WillPopScope fires
   ├─→ ScrollController         └─→ socketManager.leaveChatRoom()
   ├─→ FocusNode
   ├─→ messages RxList         GetBuilder detects disposal
   └─→ _sentMessageIds Set       └─→ ChatController.onClose()
                                    ├─→ dispose controllers
                                    ├─→ dispose focus node
                                    └─→ clear listeners

Result: No memory leaks ✅
```

## Error Handling Flow

```
Error Occurs
│
├─→ In Controller Method
│   └─→ Caught in try-catch
│       └─→ Get.snackbar()
│
├─→ In Socket
│   └─→ onChatError callback
│       └─→ Get.snackbar()
│
└─→ In UI
    └─→ Check observable state
        └─→ Show error widget if needed
```

## Comparison Table

```
┌──────────────────┬─────────────────┬────────────────────┐
│ Feature          │ Before (SetState)│ After (GetX)       │
├──────────────────┼─────────────────┼────────────────────┤
│ State Definition │ Private fields  │ Rx Observables     │
│ State Updates    │ setState()       │ .value assignment  │
│ UI Rebuilds      │ Full tree       │ Only Obx widgets   │
│ Code Organization│ Mixed           │ Separated          │
│ Memory Mgmt      │ Manual          │ Automatic          │
│ Double Messages  │ Bug ❌          │ Fixed ✅           │
│ Boilerplate      │ High            │ Low                │
│ Testability      │ Harder          │ Easier             │
└──────────────────┴─────────────────┴────────────────────┘
```

---

**Visual Guide Complete!** 📊
Use these diagrams to understand the data flow and architecture.

# My Cards Specifications

## User Stories

```
As a user,
I want to have my cards with barcodes and QR codes stored on my phone
so that I don't need to carry cards in my wallet or have 103 apps installed.
```

```
As a user,
I want to see available offers (leaflets, coupons, discounts) in my area linked to cards
so that I could see them all in one place without checking websites or 103 apps.
```
## Use Cases
### UC1.1 App Layout

#### Signed-out user, no offers [geolocation identified by GPS] course:
1. Signed-out user launches the app.
2. App checks location by using GPS and finds no offers available in the area.
3. App displays 1-page layout: Cards List UC1.2.

#### Signed-in user, offers are not available [geolocation set by user on registration] course:
1. Signed-in user launches the app.
2. App does not find offers available in the area set by the user at registration.
3. App displays 1-page layout: Cards List UC1.2.

#### Signed-out user, offers possibly available [geolocation identified by GPS] course:
1. Signed-out user launches the app.
2. App checks location by using GPS and finds offers available in the area.
3. App displays tabs layout: Cards List UC1.2 [default], Offers UC1.3, Account UC1.4.

#### Signed-in user, offers are available [geolocation set by the user on registration] course:
1. Signed-in user launches the app.
2. App find offers available in the area set by the user at registration.
3. App displays tabs layout: Cards List UC1.2 [default], Offers UC1.3, Account UC1.4.

---

### UC1.2 Cards List

#### Cards list with less than 30 cards course:
1. User opens cards list.
2. App displays:
   - Navigation bar with title and action buttons. Action buttons:
       - [Add new card] -> UC1.2.2 - displayed always.
       - [Account] -> UC1.4 - displayed only if no offers are available (not a tab layout).
   - Search input at the top.
   - Vertical cards list with 2 cards in each row.

#### Cards list with no cards course:
1. User opens cards list.
2. App displays:
   - Navigation bar with title and action buttons. Action buttons:
       - [Add new card] -> UC1.2.2 - displayed always.
       - [Account] -> UC1.4 - displayed only if no offers are available (not a tab layout).
   - Placeholder with the button [Add Card].

#### Cards list with more than 30 cards course:
1. User opens cards list.
2. App displays:
   - Navigation bar with title and action buttons. Action buttons:
       - [Add new card] -> UC1.2.2 - displayed always.
       - [Account] -> UC1.4 - displayed only if no offers are available (not a tab layout).
   - Search input at the top.
   - Vertical cards list.
   - 2 sections:
       - Recently used cards with a max of 6 recent cards, 3 cards in each row.
       - All cards with 2 cards in each row.

#### Cards list transition on scroll down course:
1. User scrolls down the list until the search input becomes covered by the navigation bar.
2. App displays search input in the navigation bar, taking up space between the leading edge and action buttons.

#### Cards list transition on scroll-up course:
1. User scrolls up the list until search input appears below the navigation bar.
2. App hides search input in the navigation bar and shows the title instead.

#### Show card information course:
1. User taps on the card.
2. App executes UC1.2.7.

---

### UC1.2.1 Search Cards List

#### Primary course:
1. User starts searching by entering the card name.
2. After each card name change, App looks for cards by user entry and displays them if available.

#### Search activation transition course:
1. User taps on search input in the list.
2. App animates the transitioning of search input to navigation bar, where it will be displayed between the leading edge and action buttons.
3. App replaces action buttons with Cancel action button.
4. App displays the keyboard.
5. App displays an empty card list.

#### Search activation alternative transition course:
1. User taps on search input in the navigation bar.
2. App replaces action buttons with Cancel action button.
4. App displays the keyboard.
5. App displays the empty list.

#### Search deactivation transition course:
1. When search input is active, User taps on Cancel.
2. App replaces action buttons with default ones.

---

### UC1.2.2 Add Card - select/take photo of card front

#### Primary course:
1. User taps on the [Add new card] button.
2. App displays:
   - Navigation bar with title and [Close] action button.
   - Explainer "Take a photo of the front of your card".
   - Video feed.
   - Action buttons at the bottom:
       - [Library]
       - [Take Photo]
       - [Flash]
3. App starts streaming a video feed from the back camera to the screen.
4. App searches for a rectangle similar to card dimensions in the video feed and outlines it.

#### Taking photo course:
1. App takes a photo from the video feed.
2. App executes process photo course.

#### Selecting a photo from the photo library course:
1. User taps on the [Library] button.
2. App shows the user's photo library.
3. User selects a photo showing the card.
4. App executes process photo course.

#### Process photo course:
1. App searches in the photo for a rectangle similar to card dimensions.
2. App selects an area which is similar to the card.
3. App cuts out the area and corrects the perspective.
4. App identifies 4 dominant colors.
5. App performs OCR on the text and uses the topmost result as the suggested name.
6. App using ML identifies card issuer.
7. App displays corrected photo UC1.2.3.    

#### Flash on/off course:
1. User taps on the [Flash] button.
2. If the flash is off, App turns on the flashlight and changes the icon to match the state.
3. If the flash is on, App turns off the flashlight and changes the icon to match the state.

---

### UC1.2.3 Add Card - review photo of the card front

#### Primary course:
1. App displays:
   - Navigation bar with title and [Close] action button.
   - Explainer "Adjust card photo if needed".
   - Card photo.
   - Action buttons at the bottom:
       - [Retake] -> UC1.2.2
       - [Crop] -> UC1.2.4
       - [OK] -> UC1.2.5

---

### UC1.2.4 Add Card - adjust the card area in the taken photo

#### Primary course:
1. App displays:
   - Navigation bar with title and [Close] action button.
   - Explainer "Adjust the border of the card in the photo".
   - Taken photo.
   - Outlined card area with dots at corners.
   - Action buttons at the bottom:
       - [Cancel] -> UC1.2.3
       - [OK]
2. User drags corners of card area to adjust card area.

#### Saving card area course:
1. User taps on the [OK] button.
2. App stores selected area.
3. App cuts out selected area and corrects perspective.
4. App displays corrected photo UC1.2.3.    

---

### UC1.2.5 Add Card - scan card barcode or QR code

#### Primary course:
1. App displays:
   - Navigation bar with title and [Close] action button.
   - Explainer "Scan barcode".
   - Card photo.
   - Transparent area with a video feed.
   - Action buttons at the bottom:
       - [Library]
       - [Flash]
2. App starts streaming a video feed from the back camera to the screen.
3. App searches for barcodes and QR codes in the video feed. When found, executes UC1.2.6.

#### Selecting a photo from the photo library course:
1. User taps on the [Library] button.
2. App shows the user's photo library.
3. User selects photo.
4. App looks for a barcode or QR code in the photo and executes UC1.2.6.
5. App displays an error if it does not find a barcode or QR code in the photo.

#### Process photo course:
1. App searches in the photo for a rectangle similar to card dimensions.
2. App selects an area which is similar to the card.
3. App cuts out the area and corrects the perspective.
4. App identifies 4 dominant colors.
5. App performs OCR on the text and uses the topmost result as a suggested name.
6. App using ML identifies card issuer.
7. App displays corrected photo UC1.2.3.    

#### Flash on/off course:
1. User taps on the [Flash] button.
2. If the flash is off, App turns on the flashlight and changes the icon to match the state.
3. If the flash is on, App turns off the flashlight and changes the icon to match the state.

---

### UC1.2.6 Add Card - review card information

#### Primary course:
1. App displays:
   - Navigation bar with title and [Close] action button.
   - Explainer "Review card information".
   - Card photo.
   - Text input for card name with suggested card name if OCR was successful.
   - Options for card background:
       - [Use Photo] [default].
       - [Background1] from dominant colors.
       - [Background2] from dominant colors.
       - [Custom] from dominant colors.
   - Barcode or QR code.
   - Suggested card issuer with the possibility to change it.
   - Action buttons at the bottom:
       - [Adjust Card Photo] -> UC1.2.3
       - [Rescan Barcode] -> UC1.2.5
       - [Store Card]

#### Store card course:
1. User taps on the [Store Card] button.
2. App stores card information.
3. App closes Add Card screen.
4. App updates Card List.

#### Selecting photo background course:
1. User taps on the [Use Photo] button.
2. App selects button and changes card background to the taken photo.

#### Selecting dominant colors background course:
1. User taps on the [Background1/2] button.
2. App selects button and changes card background to the selected color.

#### Selecting custom card background course:
1. User taps on the [Custom] button.
2. App shows a color picker.
3. User selects a color.
4. App selects button and changes button and card background colors.

#### Process photo course:
1. App searches in the photo for a rectangle similar to card dimensions.
2. App selects an area which is similar to the card.
3. App cuts out the area and corrects the perspective.
4. App identifies 4 dominant colors.
5. App performs OCR on the text and uses the topmost result as a suggested name.
6. App using ML identifies card issuer.
7. App displays corrected photo UC1.2.3.    

#### Flash on/off course:
1. User taps on the [Flash] button.
2. If the flash is off, App turns on the flashlight and changes the icon to match the state.
3. If the flash is on, App turns off the flashlight and changes the icon to match the state.

---

### UC1.2.7 Card Information

#### Primary course:
1. App displays:
   - Navigation bar with card name and [Close] action button.
   - Card photo or colored background and name.
   - Barcode or QR code.
   - Barcode or QR code value if the value is no longer than 40 characters.
   - If offers are available for this card issuer:
       - if a user is logged in - offers list
       - if a user is logged out - offers block with
           - text "Offers available. Sign in to unlock."
           - [Sign In] button

---

### UC1.3 Offers List

#### Signed-in user course:
1. Signed-in user opens offers list.
2. App displays:
   - Search input at the top.
   - Vertical offers list with 2 offers in each row.
   - Each offer has a thumbnail, store name, date, and offer details.
   - Navigation bar with the title.

#### Signed-out user course:
1. Signed-out user opens the offers list.
2. App displays:
   - Placeholder with the button [Sign In].
   - Navigation bar with the title.

#### Offers list transition in scroll down:
1. User scrolls down the list until the search input becomes covered by the navigation bar.
2. App displays search input in the navigation bar, taking up space between the leading edge and action buttons.

#### Offers list transition on scroll up:
1. User scrolls up the list until search input appears below the navigation bar.
2. App hides search input in the navigation bar and shows the title instead.

---

### UC1.4 Account

#### Signed-in user course:
1. Signed-in user opens account screen.
2. App displays:
   - User Information: username, name, country, zip code.
   - Action button [Sign Out].
   - Navigation bar with a title.

#### Signed-out user course:
1. Signed-out user opens account screen.
2. App displays:
   - Sign In button.
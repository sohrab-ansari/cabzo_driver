# Agreement Screen Debugging Guide

## Issue: Agreement Not Displaying

If you're unable to see the agreement, follow these troubleshooting steps:

### 1. **Check Console Logs**
Run your app in debug mode and check the console for these messages:
- ✅ `✅ Full Agreement URL: ...` - API fetch successful
- ❌ `❌ Server Error:` - API server issue
- ❌ `❌ Exception:` - Network/connection error

**Command to run with console output:**
```bash
flutter run -v
```

### 2. **Verify API Response**
The API should return something like:
```json
{
  "success": true,
  "data": {
    "agreement": "CorequestCabBooking/agreement-1769688023128.pdf"
  }
}
```

**Test API manually:**
```bash
curl "http://api.corezap.framekarts.com/api/v1/company/getCompany"
```

### 3. **Check PDF File Existence**
The generated URL should be:
```
http://api.corezap.framekarts.com/CorequestCabBooking/agreement-1769688023128.pdf
```

**Test if file exists (paste in browser):**
- If it shows a PDF → File exists ✅
- If it shows 404 → File doesn't exist ❌
- If it shows error → Server issue ❌

### 4. **Possible Issues & Solutions**

#### Issue A: "No agreement PDF available from company"
- **Cause**: Agreement path is null/empty in API response
- **Solution**: Check if `agreement` field exists in your API response

#### Issue B: "Server error: 404"
- **Cause**: API endpoint not working
- **Solution**: Verify API URL is correct and server is running

#### Issue C: WebView blank / PDF not loading
- **Cause**: PDF file exists but WebView can't access it
- **Solutions**:
  1. Check if PDF file is publicly accessible (no authentication needed)
  2. Try downloading the file first using the download button
  3. Check internet connection

#### Issue D: Network error or timeout
- **Cause**: Server unreachable
- **Solution**: 
  - Check internet connectivity
  - Verify server is running
  - Check if firewall is blocking requests

### 5. **New Features Added**

✨ The updated screen now has:
- **Download Button**: Download PDF to your device
- **Detailed Error Messages**: Shows exactly what went wrong
- **Console Logging**: Detailed debug information
- **Refresh Button**: Retry loading

### 6. **Debug Mode - Step by Step**

1. **Open the agreement screen**
2. **Check console for one of these:**
   - ✅ `Full Agreement URL:` → Success
   - ❌ `Agreement Path from API:` → Check if path is null
   - ❌ `API Response Status:` → Check status code
   - ❌ `Exception:` → Network error

3. **If you see error:**
   - Read the error message in red box
   - Tap "Retry" after fixing the issue
   - Check console logs

### 7. **API Response Debugging**

Add this to check your API response:
```dart
print('📦 Full API Response: ${result.toString()}');
print('📄 Agreement field: ${result['data']['agreement']}');
```

### 8. **File Paths to Check**

Current file: `lib/views/bottomNavigation/Agreement_screen.dart`

Key methods:
- `_fetchAgreement()` - Fetches agreement from API
- `_downloadPdf()` - Downloads PDF to device
- `_buildErrorWidget()` - Shows error messages

---

## Need Help?

If still not working:
1. Share console logs (Run with: `flutter run -v`)
2. Test the URL in a browser directly
3. Verify API is responding: `curl http://api.corezap.framekarts.com/api/v1/company/getCompany`
4. Check if PDF file exists on server

---

**Last Updated**: January 31, 2026

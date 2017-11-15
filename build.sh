CURRENT_USER=$(echo $USER)

xcodebuild -workspace "SeeWorld.xcworkspace" -scheme "SeeWorld" -sdk `xcodebuild -showsdks | grep "iphoneos" | tail -1 | awk '{print $4}'` -configuration Release archive -archivePath "~/Desktop/SeeWorld.xcarchive"

xcrun -sdk iphoneos PackageApplication -v ~/Desktop/seeworld/Build/Products/Release-iphoneos/SeeWorld.app -o ~/Desktop/SeeWorld.ipa

xcodebuild -exportArchive -archivePath ~/Desktop/SeeWorld.xcarchive -exportOptionsPlist "ExportOptions.plist" -exportPath ~/Desktop


cd "/Users/$CURRENT_USER/Desktop/SeeWorld.xcarchive/dSYMs/"
now="$(date +'%Y-%m-%d-%H-%M-%S')"
echo "$now"
cp -r "/Users/$CURRENT_USER/Desktop/SeeWorld.xcarchive/dSYMs/SeeWorld.app.dSYM" "/Users/$CURRENT_USER/Desktop/SeeWorld.app.dSYM"
mv "/Users/$CURRENT_USER/Desktop/SeeWorld.app.dSYM" "/Users/$CURRENT_USER/Desktop/$now"
cp -r "/Users/$CURRENT_USER/Desktop/$now" "/Users/$CURRENT_USER/Documents/Code/seeworldDSYM/$now"

fir publish ~/Desktop/SeeWorld.ipa -T "478b1cac3f06a393e54e3eebbf09f94f"

CURRENT_USER=`whoami`

xcodebuild -workspace "SeeWorld.xcworkspace" -scheme "SeeWorld" -configuration "Release" -sdk `xcodebuild -showsdks | grep "iphoneos" | tail -1 | awk '{print $4}'` -derivedDataPath "~/Desktop/seeworld" clean build

xcrun -sdk iphoneos PackageApplication -v ~/Desktop/seeworld/Build/Products/Release-iphoneos/SeeWorld.app -o ~/Desktop/SeeWorld.ipa

cd "/Users/$CURRENT_USER/Desktop/seeworld/Build/Products/Release-iphoneos/"
now="$(date +'%Y-%m-%d-%H-%M-%S')"
echo "$now"
mv "/Users/$CURRENT_USER/Desktop/seeworld/Build/Products/Release-iphoneos/SeeWorld.app.dSYM" "/Users/$CURRENT_USER/Desktop/seeworld/Build/Products/Release-iphoneos/$now"
cp -r "/Users/$CURRENT_USER/Desktop/seeworld/Build/Products/Release-iphoneos/$now" "/Users/$CURRENT_USER/Documents/Code/seeworldDSYM/$now"

#rm -r -f ~/Desktop/seeworld/

fir publish ~/Desktop/SeeWorld.ipa -T "478b1cac3f06a393e54e3eebbf09f94f"

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace Giffy.Utilities
{
    public static class DeviceDetector
    {
        public const string DeviceKey = "device";

        public static Device GetDevice(this HttpRequest request)
        {
            var deviceString = request.QueryString[DeviceKey];
            return GetDevice(deviceString);
        }

        public static Device GetDevice(string deviceString)
        {
            if (deviceString != null)
                deviceString = deviceString.ToLower();

            switch (deviceString)
            {
                case "web": return Device.Web;
                case "ios": return Device.iOS;
                case "android": return Device.Android;
                default: return Device.Unknown;
            }
        }

        public static string GetDeviceString(Device device)
        {
            switch (device)
            {
                case Device.Web: return "Web";
                case Device.iOS: return "iOS";
                case Device.Android: return "Android";
                default: return "Web";
            }
        }
    }
}
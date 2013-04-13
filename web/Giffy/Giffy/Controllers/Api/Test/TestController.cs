using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Giffy.Models;
using Giffy.Utilities;

namespace Giffy.Controllers.Api.Test
{
    public class TestController : ApiController
    {
        public ApiResult Get(string name)
        {
            var userName = this.User.Identity.Name;

            var details = new TestDetails
            {
                User = string.IsNullOrEmpty(userName) ? "None" : userName,
                Device = GetDevice().GetDeviceString()
            };

            var list = new List<Test>(5);
            for (int i = 0; i < 5; i++)
            {
                list.Add(new Test
                {
                    Name = name + " " + i,
                    Details = details,
                    First = "Data " + i,
                    Second = i
                });
            }

            return Success(list);
        }
    }

    public class Test
    {
        
        public string Name { get; set; }
        public TestDetails Details { get; set; }
        public string First { get; set; }
        public int Second { get; set; }
    }

    public class TestDetails
    {
        public string User { get; set; }
        public string Device { get; set; }
    }
}
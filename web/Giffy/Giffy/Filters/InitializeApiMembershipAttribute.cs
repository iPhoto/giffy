using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;
using Giffy.Models;
using WebMatrix.WebData;

namespace Giffy.Filters
{
    public class InitializeApiMembershipAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(HttpActionContext actionContext)
        {
            // Ensure ASP.NET Simple Membership is initialized only once per app start
            LazyInitializer.EnsureInitialized(
                ref MembershipInitializationData.initializer,
                ref MembershipInitializationData.isInitialized,
                ref MembershipInitializationData.initializerLock);
        }
    }
}
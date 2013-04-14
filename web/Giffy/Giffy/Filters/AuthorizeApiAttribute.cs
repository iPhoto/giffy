using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Net.Http;
using Giffy.Models;
using Giffy.Modules;

namespace Giffy.Filters
{
    public class AuthorizeApiAttribute : AuthorizeAttribute
    {
        public const string AuthenticationTokenKey = "AuthenticationToken";
        public const string UserNameKey = "UserName";

        public override void OnAuthorization(HttpActionContext actionContext)
        {
            base.OnAuthorization(actionContext);
            if (actionContext.Request.Headers.GetValues(AuthenticationTokenKey) != null &&
                actionContext.Request.Headers.GetValues(UserNameKey) != null)
            {
                // get value from header
                string authenticationToken = Convert.ToString(
                  actionContext.Request.Headers.GetValues(AuthenticationTokenKey).FirstOrDefault());
                string userName = Convert.ToString(
                  actionContext.Request.Headers.GetValues(UserNameKey).FirstOrDefault());

                var authenticationTokenPersistant =
                    new SecurityModule().GetPersistentToken(userName, authenticationToken);

                if (authenticationTokenPersistant != authenticationToken)
                {
                    //HttpContext.Current.Response.AddHeader("authenticationToken", authenticationToken);
                    //HttpContext.Current.Response.AddHeader("AuthenticationStatus", "NotAuthorized");
                    //actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Forbidden);
                    //return;

                    base.OnAuthorization(actionContext);
                    return;
                }

                HttpContext.Current.Response.AddHeader("authenticationToken", authenticationToken);
                HttpContext.Current.Response.AddHeader("AuthenticationStatus", "Authorized");
                return;
            }
            actionContext.Response =
              actionContext.Request.CreateResponse(HttpStatusCode.ExpectationFailed);
            actionContext.Response.ReasonPhrase = "Please provide valid inputs";
        }
    }
}
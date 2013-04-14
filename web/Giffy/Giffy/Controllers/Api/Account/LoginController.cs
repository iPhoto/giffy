using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Security;
using Giffy.Filters;
using Giffy.Models;
using Giffy.Modules;
using Microsoft.Web.WebPages.OAuth;
using WebMatrix.WebData;

namespace Giffy.Controllers.Api
{
    [InitializeApiMembershipAttribute]
    public class LoginController : ApiControllerBase
    {
        [AllowAnonymous]
        [ActionName("Default")]
        public ApiResult<Authentication> Post(LoginModel model)
        {
            if (!ModelState.IsValid)
                return Failure<Authentication>("Your data was not sent in the correct format.");

            if ((WebSecurity.IsAuthenticated && WebSecurity.IsCurrentUser(model.UserName)) || 
                 WebSecurity.Login(model.UserName, model.Password))
            {
                FormsAuthentication.SetAuthCookie(model.UserName, false);
                var authentication = new Authentication
                {
                    UserName = model.UserName,
                    Token = new SecurityModule().CreateToken(model.UserName)
                };

                return Success(authentication);
            }

            return Failure<Authentication>("Your credentials could not be recognized.");
        }
    }
}

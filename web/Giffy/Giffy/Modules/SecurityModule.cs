using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Giffy.Models;

namespace Giffy.Modules
{
    public class SecurityModule : Module
    {
        public string GetPersistentToken(string userName, string token)
        {
            userName = userName.ToLower();
            return
                (from authorization in this.Models.Authentications
                 where
                     authorization.UserName == userName &&
                     authorization.Token == token
                 select authorization.Token)
                .FirstOrDefault();
        }

        public string CreateToken(string userName)
        {
            userName = userName.ToLower();

            var currentAuthentication = 
                this.Models.Authentications

                .FirstOrDefault(a => a.UserName == userName);

            if (currentAuthentication == null)
            {
                currentAuthentication = new Authentication
                {
                    UserName = userName,
                    Token = string.Empty
                };

                this.Models.Authentications.Add(currentAuthentication);
                
            }

            currentAuthentication.Token = Guid.NewGuid().ToString();
            this.UserModels.SaveChanges();

            return currentAuthentication.Token;
        }

        public void DeleteToken(string userName)
        {
            userName = userName.ToLower();

            var currentAuthentication =
                this.Models.Authentications
                .FirstOrDefault(a => a.UserName == userName);

            if (currentAuthentication == null)
                return;

            this.Models.Authentications.Remove(currentAuthentication);
            this.Models.SaveChanges();
        }
    }
}
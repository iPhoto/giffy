using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http.Filters;
using Giffy.Models;

namespace Giffy.Filters
{
    public class ExceptionHandlerAttribute : ExceptionFilterAttribute
    {
        public override void OnException(HttpActionExecutedContext actionExecutedContext)
        {
            if (HttpContext.Current.User == null)
            {
                base.OnException(actionExecutedContext);
                return;
            }

            actionExecutedContext.Response =
                actionExecutedContext.Request
                .CreateResponse<ApiResult<bool>>(
                    HttpStatusCode.OK,
                    new ApiResult<bool>
                    {
                        Success = false,
                        Data = default(bool),
                        Message = actionExecutedContext.Exception.Message
                    });
        }
    }
}
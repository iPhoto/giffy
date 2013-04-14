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
                        Message = 
                            CompileExceptionMessage(
                                actionExecutedContext.Exception)
                    });
        }

        private string CompileExceptionMessage(Exception exception)
        {
            var messages = new List<string>();

            while (exception != null)
            {
                messages.Add(exception.Message);
                exception = exception.InnerException;
            }

            return messages.Aggregate((x, y) => x + " " + y);
        }
    }
}
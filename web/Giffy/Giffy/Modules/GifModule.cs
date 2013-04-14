using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Giffy.Models.Gifs;
using Giffy.Repositories;

namespace Giffy.Modules
{
    public class GifModule : Module
    {
        public GifBuilder StartBuild()
        {
            var builder = new GifBuilder();
            builder.Name = 
                HttpContext.Current.User.Identity.Name + " " +
                (new GifContainerRepository().Models.Count() + 1);

            var repository = new GifBuilderRepository();
            if (!repository.Create(builder))
                throw new InvalidOperationException();

            return builder;
        }

        public void AddToBuild(GifComponent component)
        {
            var repository = new GifComponentRepository();
            if (!repository.Create(component))
                throw new InvalidOperationException();
        }

        public GifContainer FinishBuild(int builderID)
        {
            var builderRepository = new GifBuilderRepository();
            var componentRepository = new GifComponentRepository();

            var builder = 
                builderRepository
                .Get(builderID);

            var gifContainer = builder.Build();
            var repository = new GifContainerRepository();

            gifContainer.Name = builder.Name;
            gifContainer.Description = string.Empty;

            if (!repository.Create(gifContainer))
                throw new InvalidOperationException();

            foreach (var component in builder.Components.ToList())
                componentRepository.Delete(component);

            builderRepository.Delete(builder);

            return gifContainer;
        }

        public void AddDescription(int gifContainerID, string name, string description)
        {
            var repository = new GifContainerRepository();
            var gifContainer = repository.Get(gifContainerID);

            gifContainer.Name = name;
            gifContainer.Description = description;
            repository.Update(gifContainer);
        }
    }
}
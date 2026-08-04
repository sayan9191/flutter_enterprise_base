/// Maps between DTO (model) and domain entity.
abstract class BaseMapper<Entity, Model> {
  Entity toEntity(Model model);
  Model toModel(Entity entity);
  List<Entity> toEntityList(List<Model> models) =>
      models.map(toEntity).toList();
}

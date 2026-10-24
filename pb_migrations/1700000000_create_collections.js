/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const users = app.findCollectionByNameOrId("_pb_users_auth_");

  // Coleção tarefas
  const tarefas = new Collection({
    name: "tarefas",
    type: "base",
    listRule: "@request.auth.id != '' && user = @request.auth.id",
    viewRule: "@request.auth.id != '' && user = @request.auth.id",
    createRule: "@request.auth.id != '' && @request.body.user = @request.auth.id",
    updateRule: "@request.auth.id != '' && user = @request.auth.id",
    deleteRule: "@request.auth.id != '' && user = @request.auth.id",
    fields: [
      { name: "titulo", type: "text", required: true },
      { name: "materia", type: "text", required: true },
      { name: "prioridade", type: "select", required: true, values: ["alta", "media", "baixa"], maxSelect: 1 },
      { name: "concluida", type: "bool" },
      { name: "prazo", type: "date" },
      { name: "user", type: "relation", required: true, collectionId: users.id, cascadeDelete: true, maxSelect: 1 }
    ]
  });
  app.save(tarefas);

  // Coleção provas
  const provas = new Collection({
    name: "provas",
    type: "base",
    listRule: "@request.auth.id != '' && user = @request.auth.id",
    viewRule: "@request.auth.id != '' && user = @request.auth.id",
    createRule: "@request.auth.id != '' && @request.body.user = @request.auth.id",
    updateRule: "@request.auth.id != '' && user = @request.auth.id",
    deleteRule: "@request.auth.id != '' && user = @request.auth.id",
    fields: [
      { name: "titulo", type: "text", required: true },
      { name: "materia", type: "text", required: true },
      { name: "data", type: "date", required: true },
      { name: "sala", type: "text" },
      { name: "user", type: "relation", required: true, collectionId: users.id, cascadeDelete: true, maxSelect: 1 }
    ]
  });
  app.save(provas);
}, (app) => {
  const tarefas = app.findCollectionByNameOrId("tarefas");
  if (tarefas) app.delete(tarefas);

  const provas = app.findCollectionByNameOrId("provas");
  if (provas) app.delete(provas);
});

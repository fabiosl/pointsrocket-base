object @domain
if defined?(@for_world) && @for_world
  extends "api/domains/for_world", object: DomainDecorator.decorate(@domain)
else
  extends "api/domains/domain", object: DomainDecorator.decorate(@domain)
end

import fastifySwagger from '@fastify/swagger';
import fastifySwaggerUi from '@fastify/swagger-ui';
import Fastify, { FastifyInstance, FastifyReply, FastifyRequest } from 'fastify';

const app = Fastify();

app.register(fastifySwagger);
app.register(fastifySwaggerUi);

const userRoutes = async (server: FastifyInstance) => {

    server.get('/', {
      schema: {
        response: {
          200: {
            type: 'object',
            properties: {
              name: { type: 'string' },
              age: { type: 'number' },
            },
          },
        },
      },
      handler: async (request: FastifyRequest<{}>, reply: FastifyReply) => {
        return reply.code(200).send("{name: \"john\", age:12}");
      },
    });

    server.addSchema({
        $id: 'createUseSchema',
        type: 'object',
        properties: {
          name: { type: 'string'},
          age: { type: 'number' }
        },
      });

    server.post('/', {
        schema: {
          body: { $ref: 'createUseSchema#' },
          response: {
            201: {
              type: 'object',
              properties: {
                name: { type: 'string' },
                age: { type: 'number' },
              },
            },
          },
        },
        handler: async (
          request: FastifyRequest<{
              Body: {
              name: string;
              age: number;
            };
          }>,
          reply: FastifyReply,
        ) => {
          const body = request.body;
    
          return reply.code(201).send(body);
        },
      });
};
  
app.register(userRoutes, { prefix: 'api/users' });

if (require.main === module) {
    app.listen({ port: 3000, host: '0.0.0.0' }, (err) => {
      if (err) console.error(err)
      console.log('server listening on 3000');
    })
  } else {
    module.exports = app
  }

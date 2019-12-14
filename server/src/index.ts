import "reflect-metadata";
import "dotenv/config";
import {createConnection} from "typeorm";
import {ApolloServer} from "apollo-server-express";
import express from "express";
import multer from "multer";
import corsMiddleware from 'cors'
import {schema} from "./schema";
import {PORT, UPLOAD_DIR} from "./config";
import {getTokenFromRequest, getUserIdFromToken} from "./auth";
import {User} from "./entity/User";
import http from 'http'
import {RoleDirective} from "./directives";
import {resolvers} from './resolvers'
import {v4} from "uuid";
import {authUploadRequest} from "./upload";
import {fileHandler, fileUploadSuccessHandler} from "./file";

const startServer = async () => {

    const server = new ApolloServer({
        typeDefs: schema,
        resolvers,
        playground: process.env.DISABLE_PLAYGROUND !== 'true',
        introspection: process.env.DISABLE_PLAYGROUND !== 'true',
        context: async (ctx: any) => {
            if (ctx.connection) {
                return ctx.connection.context;
            } else {
                const req = ctx.req;
                const token = getTokenFromRequest(req);
                let user = null;
                if (token != "") {
                    const userId = await getUserIdFromToken(token);
                    user = await User.findOne(userId);
                }
                return {user};

            }

        },
        schemaDirectives: {
            hasRole: RoleDirective
        }
    });


    await createConnection();
    // update user status to offline
    const app = express();

    const corsOptions = {
        credentials: true,
        origin: '*',
    };
    server.applyMiddleware({
        app,
        cors: corsOptions,
        bodyParserConfig: {limit: "20mb"},
    });
    app.use(corsMiddleware(corsOptions));

    // Handle upload

    const storage = multer.diskStorage({
        destination: function (_req: any, _file: any, cb) {
            cb(null, UPLOAD_DIR)
        },
        filename: function (_req, file, cb) {
            cb(null, `${v4()}-${file.originalname}`);
        }
    });

    const upload = multer({storage: storage});
    app.post('/upload',
        authUploadRequest,
        upload.single('file'),
        fileUploadSuccessHandler);


    app.get('/file/:name', fileHandler);


    const httpServer = http.createServer(app);
    server.installSubscriptionHandlers(httpServer);

    httpServer.listen({port: PORT}, () =>
        console.log(`🚀 Server ready at http://localhost:${PORT}${server.graphqlPath}`)
    );
};

startServer().catch((e) => {
    throw e;
});
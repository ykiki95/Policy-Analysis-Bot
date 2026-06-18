import type { ErrorRequestHandler, RequestHandler } from "express";

/** 등록된 라우트가 없을 때 일관된 404 JSON 을 반환한다. */
export const notFoundHandler: RequestHandler = (req, res) => {
  res.status(404).json({ error: `경로를 찾을 수 없습니다: ${req.method} ${req.path}` });
};

/**
 * 전역 에러 핸들러(Express 5). 라우트에서 throw 되거나 next(err) 로 전달된
 * 모든 에러를 잡아 일관된 {error} JSON 으로 응답하고, 서버 로그에 기록한다.
 * 내부 메시지는 클라이언트에 노출하지 않는다.
 */
export const errorHandler: ErrorRequestHandler = (err, req, res, _next) => {
  const status =
    typeof (err as { status?: number; statusCode?: number })?.status === "number"
      ? (err as { status: number }).status
      : typeof (err as { statusCode?: number })?.statusCode === "number"
        ? (err as { statusCode: number }).statusCode
        : 500;

  req.log.error({ err, status }, "Unhandled request error");

  if (res.headersSent) return;

  res.status(status).json({
    error:
      status >= 500
        ? "서버 내부 오류가 발생했습니다."
        : ((err as { message?: string })?.message ?? "요청을 처리할 수 없습니다."),
  });
};

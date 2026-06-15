export function jsonReady<T>(data: T): unknown {
  return JSON.parse(JSON.stringify(data));
}

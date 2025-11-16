export const saveAuth = (token, user) => {
  localStorage.setItem("token", token);
  localStorage.setItem("user", JSON.stringify(user));
};


export const getToken = () => {
  return localStorage.getItem("token");
};


export const getUser = () => {
  const raw = localStorage.getItem("user");
  if (!raw) return null;
  try {
    return JSON.parse(raw);
  } catch {
    return null;
  }
};


export const clearAuth = () => {
  localStorage.removeItem("token");
  localStorage.removeItem("user");
};

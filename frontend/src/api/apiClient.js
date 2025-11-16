import axios from "axios";
import { getToken } from "../utils/auth";


const apiClient = axios.create({
  baseURL: "http://localhost:5001/api"
});


apiClient.interceptors.request.use((config) => {
  const token = getToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default apiClient;
